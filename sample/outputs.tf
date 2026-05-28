# PC-IAC-007: Outputs granulares para validar la infraestructura creada

output "http_namespace_ids" {
  description = "IDs de los namespaces HTTP creados por el módulo."
  value       = module.cloudmap.http_namespace_ids
}

output "http_namespace_arns" {
  description = "ARNs de los namespaces HTTP creados por el módulo."
  value       = module.cloudmap.http_namespace_arns
}

output "private_dns_namespace_ids" {
  description = "IDs de los namespaces DNS privados creados por el módulo."
  value       = module.cloudmap.private_dns_namespace_ids
}

output "private_dns_namespace_arns" {
  description = "ARNs de los namespaces DNS privados creados por el módulo."
  value       = module.cloudmap.private_dns_namespace_arns
}

output "all_namespace_ids" {
  description = "Mapa consolidado de IDs de todos los namespaces creados."
  value       = module.cloudmap.all_namespace_ids
}

output "all_namespace_arns" {
  description = "Mapa consolidado de ARNs de todos los namespaces creados."
  value       = module.cloudmap.all_namespace_arns
}
