# PC-IAC-007: Outputs granulares - solo IDs y ARNs necesarios
# PC-IAC-014: Splat Expressions con values()[*] para colecciones for_each
# PC-IAC-003: Nomenclatura snake_case en nombres de outputs

output "http_namespace_ids" {
  description = "Mapa de IDs de los namespaces HTTP creados. Clave: identificador lógico del namespace."
  value = {
    for k, v in aws_service_discovery_http_namespace.this : k => v.id
  }
}

output "http_namespace_arns" {
  description = "Mapa de ARNs de los namespaces HTTP creados. Clave: identificador lógico del namespace."
  value = {
    for k, v in aws_service_discovery_http_namespace.this : k => v.arn
  }
}

output "private_dns_namespace_ids" {
  description = "Mapa de IDs de los namespaces DNS privados creados. Clave: identificador lógico del namespace."
  value = {
    for k, v in aws_service_discovery_private_dns_namespace.this : k => v.id
  }
}

output "private_dns_namespace_arns" {
  description = "Mapa de ARNs de los namespaces DNS privados creados. Clave: identificador lógico del namespace."
  value = {
    for k, v in aws_service_discovery_private_dns_namespace.this : k => v.arn
  }
}

output "public_dns_namespace_ids" {
  description = "Mapa de IDs de los namespaces DNS públicos creados. Clave: identificador lógico del namespace."
  value = {
    for k, v in aws_service_discovery_public_dns_namespace.this : k => v.id
  }
}

output "public_dns_namespace_arns" {
  description = "Mapa de ARNs de los namespaces DNS públicos creados. Clave: identificador lógico del namespace."
  value = {
    for k, v in aws_service_discovery_public_dns_namespace.this : k => v.arn
  }
}

output "all_namespace_ids" {
  description = "Mapa consolidado de IDs de todos los namespaces creados (HTTP, DNS_PRIVATE, DNS_PUBLIC). Clave: identificador lógico."
  value = merge(
    { for k, v in aws_service_discovery_http_namespace.this : k => v.id },
    { for k, v in aws_service_discovery_private_dns_namespace.this : k => v.id },
    { for k, v in aws_service_discovery_public_dns_namespace.this : k => v.id }
  )
}

output "all_namespace_arns" {
  description = "Mapa consolidado de ARNs de todos los namespaces creados (HTTP, DNS_PRIVATE, DNS_PUBLIC). Clave: identificador lógico."
  value = merge(
    { for k, v in aws_service_discovery_http_namespace.this : k => v.arn },
    { for k, v in aws_service_discovery_private_dns_namespace.this : k => v.arn },
    { for k, v in aws_service_discovery_public_dns_namespace.this : k => v.arn }
  )
}
