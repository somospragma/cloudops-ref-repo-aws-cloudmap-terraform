# PC-IAC-012: Estructuras de Datos y Reutilización en Locals
# PC-IAC-003: Nomenclatura Estándar - Construcción centralizada de nombres
# PC-IAC-009: Lógica de transformación exclusiva en locals.tf

locals {
  # ─── Prefijo de Gobernanza (PC-IAC-003, PC-IAC-012) ──────────────────────
  # Prefijo base reutilizable para construir todos los nombres de recursos
  governance_prefix = "${var.client}-${var.project}-${var.environment}"

  # ─── Nomenclatura de Namespaces (PC-IAC-003) ─────────────────────────────
  # Patrón: {client}-{project}-{environment}-ns-{key}
  # Si el usuario provee un nombre explícito, se respeta; de lo contrario se construye automáticamente.
  namespace_names = {
    for k, v in var.namespaces : k => "${local.governance_prefix}-ns-${k}"
  }

  # ─── Aplanamiento de Servicios (PC-IAC-012) ──────────────────────────────
  # Convierte la estructura anidada namespaces[].services[] en un mapa plano
  # para facilitar la iteración con for_each en main.tf (PC-IAC-010)
  services_flat = flatten([
    for ns_key, ns in var.namespaces : [
      for svc_key, svc in ns.services : {
        key                        = "${ns_key}-${svc_key}"
        namespace_key              = ns_key
        name                       = "${local.governance_prefix}-svc-${svc_key}"
        description                = svc.description
        dns_records                = svc.dns_records
        health_check_config        = svc.health_check_config
        health_check_custom_config = svc.health_check_custom_config
        additional_tags            = svc.additional_tags
      }
    ]
  ])

  # Mapa de servicios para consumo con for_each (PC-IAC-010)
  services_map = {
    for svc in local.services_flat : svc.key => svc
  }
}
