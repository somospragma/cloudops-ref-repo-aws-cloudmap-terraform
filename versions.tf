# PC-IAC-006: Versiones y Estabilidad
# PC-IAC-005: Providers - Alias consumidor aws.project
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.31.0"
      configuration_aliases = [aws.project]
    }
  }
}
