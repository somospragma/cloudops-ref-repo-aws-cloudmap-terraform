# PC-IAC-002: Variables con type, description y validation
# Variables de entrada del ejemplo sample/

# ─── Variables de Gobernanza ─────────────────────────────────────────────────

variable "client" {
  description = "Nombre del cliente. Se usa para construir la nomenclatura estándar."
  type        = string

  validation {
    condition     = length(var.client) > 0
    error_message = "El valor de 'client' no puede estar vacío."
  }
}

variable "project" {
  description = "Nombre del proyecto. Se usa para construir la nomenclatura estándar."
  type        = string

  validation {
    condition     = length(var.project) > 0
    error_message = "El valor de 'project' no puede estar vacío."
  }
}

variable "environment" {
  description = "Entorno de despliegue. Valores permitidos: dev, qa, pdn."
  type        = string

  validation {
    condition     = contains(["dev", "qa", "pdn", "prod"], var.environment)
    error_message = "El entorno debe ser uno de: dev, qa, pdn, prod."
  }
}

variable "region" {
  description = "Región de AWS donde se desplegarán los recursos."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "El valor de 'region' no puede estar vacío."
  }
}

variable "deploy_role_arn" {
  description = "ARN del rol IAM que Terraform asumirá para desplegar los recursos."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.deploy_role_arn))
    error_message = "El 'deploy_role_arn' debe ser un ARN de IAM válido (arn:aws:iam::...)."
  }
}

# ─── Variables de Configuración ──────────────────────────────────────────────

variable "namespaces" {
  description = "Mapa de configuración de namespaces Cloud Map. Los vpc_id vacíos serán inyectados automáticamente desde el data source de VPC."
  type = map(object({
    description = optional(string, "")
    type        = optional(string, "HTTP")
    vpc_id      = optional(string, null)
    services    = optional(map(object({
      description                = optional(string, "")
      dns_records                = optional(list(object({ ttl = optional(number, 10), type = optional(string, "A") })), [])
      health_check_config        = optional(object({ type = string, resource_path = optional(string, "/health"), failure_threshold = optional(number, 1) }), null)
      health_check_custom_config = optional(object({ failure_threshold = optional(number, 1) }), null)
      additional_tags            = optional(map(string), {})
    })), {})
    dns_properties  = optional(object({ dns_ttl = optional(number, 60), routing_policy = optional(string, "MULTIVALUE"), soa = optional(object({ ttl = optional(number, 900), contact = optional(string, "") }), null) }), null)
    additional_tags = optional(map(string), {})
  }))
  default = {}
}

variable "common_tags" {
  description = "Etiquetas transversales de gobernanza aplicadas a todos los recursos via default_tags del provider (PC-IAC-004)."
  type        = map(string)
  default     = {}
}
