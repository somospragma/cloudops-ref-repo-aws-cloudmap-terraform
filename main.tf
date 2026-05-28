# PC-IAC-010: for_each obligatorio para colecciones de recursos
# PC-IAC-005: provider = aws.project en cada recurso
# PC-IAC-004: tags con merge() - Name explícito + additional_tags
# PC-IAC-023: Responsabilidad única - solo recursos intrínsecos de Cloud Map
# PC-IAC-003: Nombres construidos desde locals.tf

# ─── Namespace HTTP ───────────────────────────────────────────────────────────
resource "aws_service_discovery_http_namespace" "this" {
  provider = aws.project

  for_each = {
    for k, v in var.namespaces : k => v
    if v.type == "HTTP"
  }

  name        = local.namespace_names[each.key]
  description = each.value.description

  # PC-IAC-004: Etiqueta Name explícita + additional_tags del usuario
  tags = merge(
    {
      Name = local.namespace_names[each.key]
    },
    each.value.additional_tags
  )
}

# ─── Namespace DNS Privado ────────────────────────────────────────────────────
resource "aws_service_discovery_private_dns_namespace" "this" {
  provider = aws.project

  for_each = {
    for k, v in var.namespaces : k => v
    if v.type == "DNS_PRIVATE"
  }

  name        = local.namespace_names[each.key]
  description = each.value.description
  vpc         = each.value.vpc_id # vpc_id inyectado desde Root via variable (PC-IAC-011, PC-IAC-023)

  # PC-IAC-004: Etiqueta Name explícita + additional_tags del usuario
  tags = merge(
    {
      Name = local.namespace_names[each.key]
    },
    each.value.additional_tags
  )
}

# ─── Namespace DNS Público ────────────────────────────────────────────────────
resource "aws_service_discovery_public_dns_namespace" "this" {
  provider = aws.project

  for_each = {
    for k, v in var.namespaces : k => v
    if v.type == "DNS_PUBLIC"
  }

  name        = local.namespace_names[each.key]
  description = each.value.description

  # PC-IAC-004: Etiqueta Name explícita + additional_tags del usuario
  tags = merge(
    {
      Name = local.namespace_names[each.key]
    },
    each.value.additional_tags
  )
}
