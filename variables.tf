variable "project" {
  description = "Nombre del proyecto asociado a los recursos"
  type        = string
  
  validation {
    condition     = length(var.project) > 0
    error_message = "El valor de project no puede estar vacío."
  }
}

variable "client" {
  description = "Nombre del cliente asociado a los recursos"
  type        = string
  
  validation {
    condition     = length(var.client) > 0
    error_message = "El valor de client no puede estar vacío."
  }
}

variable "environment" {
  description = "Entorno en el que se desplegarán los recursos (dev, qa, pdn)"
  type        = string
  
  validation {
    condition     = contains(["dev", "qa", "pdn"], var.environment)
    error_message = "El entorno debe ser uno de: dev, qa, pdn."
  }
}

variable "namespaces" {
  description = "Configuración de los namespaces de Cloud Map"
  type = map(object({
    name        = optional(string, null)
    description = optional(string, "")
    type        = optional(string, "HTTP")  # HTTP, DNS_PRIVATE, DNS_PUBLIC
    vpc_id      = optional(string, null)    # Requerido para DNS_PRIVATE
    
    # Configuración de servicios
    services = optional(map(object({
      description = optional(string, "")
      
      # Configuración de DNS (para namespaces DNS)
      dns_records = optional(list(object({
        ttl  = optional(number, 10)
        type = optional(string, "A")
      })), [])
      
      # Configuración de comprobaciones de salud
      health_check_config = optional(object({
        type                = string  # HTTP, HTTPS, TCP
        resource_path       = optional(string, "/health")
        failure_threshold   = optional(number, 1)
      }), null)
      
      health_check_custom_config = optional(object({
        failure_threshold = optional(number, 1)
      }), null)
      
      # Etiquetas adicionales
      additional_tags = optional(map(string), {})
    })), {})
    
    # Solo para namespaces DNS
    dns_properties = optional(object({
      dns_ttl             = optional(number, 60)
      routing_policy      = optional(string, "MULTIVALUE")  # MULTIVALUE o WEIGHTED
      soa = optional(object({
        ttl     = optional(number, 900)
        contact = optional(string, "")
      }), null)
    }), null)
    
    # Etiquetas adicionales
    additional_tags = optional(map(string), {})
  }))
  default = {}
}