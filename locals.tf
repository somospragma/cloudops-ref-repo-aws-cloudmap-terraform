locals {
  namespace_names = {
    for k, v in var.namespaces : k => v.name != null ? v.name : "${var.client}-${var.project}-${var.environment}-${k}-ns"
  }
  
  # Procesar servicios para cada namespace
  services = flatten([
    for ns_key, ns in var.namespaces : [
      for svc_key, svc in ns.services : {
        key           = "${ns_key}-${svc_key}"
        namespace_key = ns_key
        name          = "${var.client}-${var.project}-${var.environment}-${svc_key}"
        description   = svc.description
        dns_records   = svc.dns_records
        health_check_config = svc.health_check_config
        health_check_custom_config = svc.health_check_custom_config
        additional_tags = svc.additional_tags
      }
    ]
  ])
  
  # Convertir a mapa para facilitar el acceso
  services_map = {
    for svc in local.services : svc.key => svc
  }
}
