# PC-IAC-005: Provider principal con alias "principal"
# PC-IAC-004: default_tags para etiquetas transversales de gobernanza
# PC-IAC-006: Versiones con pinning estricto para el Root

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # PC-IAC-008: Backend S3 con cifrado y bloqueo
  # Descomentar y configurar antes de usar en ambientes compartidos (qa, pdn)
  # backend "s3" {
  #   bucket       = "{client}-{project}-{environment}-tfstate"
  #   key          = "cloudmap/terraform.tfstate"
  #   region       = "us-east-1"
  #   encrypt      = true
  #   use_lockfile = true
  # }
}

# PC-IAC-005: Provider principal con alias "principal"
# PC-IAC-004: default_tags aplica etiquetas transversales a todos los recursos
provider "aws" {
  alias  = "principal"
  region = var.region

  # PC-IAC-005: Asunción de rol para principio de menor privilegio
  assume_role {
    role_arn = var.deploy_role_arn
  }

  # PC-IAC-004: Etiquetas transversales de gobernanza
  default_tags {
    tags = var.common_tags
  }
}
