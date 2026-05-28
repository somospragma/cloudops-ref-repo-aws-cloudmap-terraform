# PC-IAC-002: Variables - Declaración con type, description y validation obligatorios
# PC-IAC-009: Tipos de Datos - Uso de map(object) para estabilidad con for_each

# ─── Variables de Gobernanza (PC-IAC-002, PC-IAC-003) ───────────────────────

variable "client" {
  description = "Nombre del cliente asociado a los recursos. Se usa para construir la nomenclatura estándar {client}-{project}-{environment}."
  type        = string

  validation {
    condition     = length(var.client) > 0
    error_message = "El valor de 'client' no puede estar vacío."
  }
}

variable "project" {
  description = "Nombre del proyecto asociado a los recursos. Se usa para construir la nomenclatura estándar {client}-{project}-{environment}."
  type        = string

  validation {
    condition     = length(var.project) > 0
    error_message = "El valor de 'project' no puede estar vacío."
  }
}

variable "environment" {
  description = "Entorno en el que se desplegarán los recursos. Valores permitidos: dev, qa, pdn."
  type        = string

  validation {
    condition     = contains(["dev", "qa", "pdn", "prod"], var.environment)
    error_message = "El entorno debe ser uno de: dev, qa, pdn, prod."
  }
}

# ─── Variables de Configuración del Recurso (PC-IAC-002, PC-IAC-009) ────────

variable "namespaces" {
  description = <<-EOT
    Mapa de configuración de los namespaces de AWS Cloud Map.
    Cada clave del mapa es un identificador lógico único del namespace.
    Tipos soportados: HTTP, DNS_PRIVATE, DNS_PUBLIC.
    Para DNS_PRIVATE, el campo vpc_id es obligatorio.
  EOT
  type = map(object({
    description = optional(string, "")
    type        = optional(string, "HTTP") # HTTP | DNS_PRIVATE | DNS_PUBLIC
    vpc_id      = optional(string, null)   # Requerido para DNS_PRIVATE; inyectar desde Root via data source

    # Configuración de servicios dentro del namespace
    services = optional(map(object({
      description = optional(string, "")

      # Registros DNS (aplica a namespaces DNS)
      dns_records = optional(list(object({
        ttl  = optional(number, 10)
        type = optional(string, "A")
      })), [])

      # Comprobación de salud estándar (para namespaces DNS_PUBLIC)
      health_check_config = optional(object({
        type              = string           # HTTP | HTTPS | TCP
        resource_path     = optional(string, "/health")
        failure_threshold = optional(number, 1)
      }), null)

      # Comprobación de salud personalizada (para namespaces DNS_PRIVATE)
      health_check_custom_config = optional(object({
        failure_threshold = optional(number, 1)
      }), null)

      additional_tags = optional(map(string), {})
    })), {})

    # Propiedades DNS opcionales (aplica a namespaces DNS)
    dns_properties = optional(object({
      dns_ttl        = optional(number, 60)
      routing_policy = optional(string, "MULTIVALUE") # MULTIVALUE | WEIGHTED
      soa = optional(object({
        ttl     = optional(number, 900)
        contact = optional(string, "")
      }), null)
    }), null)

    additional_tags = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.namespaces :
      contains(["HTTP", "DNS_PRIVATE", "DNS_PUBLIC"], v.type)
    ])
    error_message = "El tipo de namespace debe ser uno de: HTTP, DNS_PRIVATE, DNS_PUBLIC."
  }

  validation {
    condition = alltrue([
      for k, v in var.namespaces :
      v.type != "DNS_PRIVATE" || (v.vpc_id != null && length(v.vpc_id) > 0)
    ])
    error_message = "El campo 'vpc_id' es obligatorio para namespaces de tipo DNS_PRIVATE."
  }
}
