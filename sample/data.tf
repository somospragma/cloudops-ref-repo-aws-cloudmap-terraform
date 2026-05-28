# PC-IAC-011: Data Sources en el Root (sample actúa como Root)
# PC-IAC-017: Comunicación entre dominios via Data Sources
# Los Data Sources obtienen IDs dinámicos que serán inyectados en locals.tf

# VPC para namespaces DNS_PRIVATE
# Se busca por tag Name siguiendo la nomenclatura estándar PC-IAC-003
data "aws_vpc" "selected" {
  provider = aws.principal

  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-vpc"]
  }
}
