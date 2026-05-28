# PC-IAC-026: sample/main.tf SOLO invoca el módulo - sin bloques locals{}
# PC-IAC-013: Orden obligatorio de atributos en el bloque module (A→B→C→D→E→F)
# PC-IAC-015: Consumo del módulo con referencia local (../); en producción usar ref=vX.Y.Z

module "cloudmap" {
  # A. Fuente del Módulo (PC-IAC-015)
  # En ambientes compartidos (qa, pdn) usar referencia remota versionada:
  # source = "git::https://github.com/somospragma/cloudops-ref-repo-aws-cloudmap-terraform.git?ref=v1.0.0"
  source = "../"

  # B. Providers (PC-IAC-005)
  providers = {
    aws.project = aws.principal
  }

  # C. Variables de Gobernanza (PC-IAC-003, PC-IAC-013)
  client      = var.client
  project     = var.project
  environment = var.environment

  # E. Variables de Configuración - consumir local transformado (PC-IAC-026)
  namespaces = local.namespaces_transformed
}
