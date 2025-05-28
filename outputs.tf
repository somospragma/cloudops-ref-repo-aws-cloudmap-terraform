output "http_namespaces" {
  description = "Información de los namespaces HTTP creados"
  value = {
    for k, v in aws_service_discovery_http_namespace.this : k => {
      id   = v.id
      arn  = v.arn
      name = v.name
    }
  }
}

output "private_dns_namespaces" {
  description = "Información de los namespaces DNS privados creados"
  value = {
    for k, v in aws_service_discovery_private_dns_namespace.this : k => {
      id   = v.id
      arn  = v.arn
      name = v.name
      vpc  = v.vpc
    }
  }
}

output "public_dns_namespaces" {
  description = "Información de los namespaces DNS públicos creados"
  value = {
    for k, v in aws_service_discovery_public_dns_namespace.this : k => {
      id   = v.id
      arn  = v.arn
      name = v.name
    }
  }
}

output "namespaces" {
  description = "Mapa consolidado de todos los namespaces creados"
  value = merge(
    {
      for k, v in aws_service_discovery_http_namespace.this : k => {
        id   = v.id
        arn  = v.arn
        name = v.name
        type = "HTTP"
      }
    },
    {
      for k, v in aws_service_discovery_private_dns_namespace.this : k => {
        id   = v.id
        arn  = v.arn
        name = v.name
        type = "DNS_PRIVATE"
        vpc  = v.vpc
      }
    },
    {
      for k, v in aws_service_discovery_public_dns_namespace.this : k => {
        id   = v.id
        arn  = v.arn
        name = v.name
        type = "DNS_PUBLIC"
      }
    }
  )
}