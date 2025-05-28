
# HTTP Namespace
resource "aws_service_discovery_http_namespace" "this" {
  provider = aws.project
  for_each = {
    for k, v in var.namespaces : k => v
    if v.type == "HTTP"
  }
  
  name        = local.namespace_names[each.key]
  description = each.value.description
  
  tags = merge(
    {
      Name        = local.namespace_names[each.key]
    },
    each.value.additional_tags
  )
}

# DNS Private Namespace
resource "aws_service_discovery_private_dns_namespace" "this" {
  provider = aws.project
  for_each = {
    for k, v in var.namespaces : k => v
    if v.type == "DNS_PRIVATE"
  }
  
  name        = local.namespace_names[each.key]
  description = each.value.description
  vpc         = each.value.vpc_id
  
  tags = merge(
    {
      Name        = local.namespace_names[each.key]
    },
    each.value.additional_tags
  )
}

# DNS Public Namespace
resource "aws_service_discovery_public_dns_namespace" "this" {
  provider = aws.project
  for_each = {
    for k, v in var.namespaces : k => v
    if v.type == "DNS_PUBLIC"
  }
  
  name        = local.namespace_names[each.key]
  description = each.value.description
  
  tags = merge(
    {
      Name        = local.namespace_names[each.key]
    },
    each.value.additional_tags
  )
}
