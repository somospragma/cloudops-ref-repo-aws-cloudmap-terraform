# Ejemplo de Uso - cloudops-ref-repo-aws-cloudmap-terraform

Este directorio contiene un ejemplo funcional completo de cómo consumir el módulo de referencia de AWS Cloud Map siguiendo el patrón PC-IAC-026.

## Flujo de Datos (PC-IAC-026)

```
terraform.tfvars → variables.tf → locals.tf → main.tf → module
```

1. `terraform.tfvars` declara la configuración base sin IDs hardcodeados.
2. `data.tf` obtiene IDs dinámicos (VPC) desde AWS.
3. `locals.tf` transforma la configuración inyectando los IDs dinámicos.
4. `main.tf` invoca el módulo usando `local.*` (nunca `var.*` directamente).

## Prerrequisitos

- Terraform `>= 1.0.0`
- AWS CLI configurado con credenciales válidas
- Una VPC existente con el tag `Name = "{client}-{project}-{environment}-vpc"` (para namespaces DNS_PRIVATE)

## Ejecución

```bash
cd sample/

# Inicializar
terraform init

# Revisar el plan
terraform plan -var-file="terraform.tfvars"

# Aplicar
terraform apply -var-file="terraform.tfvars"

# Destruir
terraform destroy -var-file="terraform.tfvars"
```

## Estructura

| Archivo | Responsabilidad |
|---------|----------------|
| `terraform.tfvars` | Valores de configuración base (sin IDs hardcodeados) |
| `variables.tf` | Declaración de variables de entrada del ejemplo |
| `data.tf` | Data Sources para obtener IDs dinámicos (VPC) |
| `locals.tf` | Transformación: inyecta IDs dinámicos en la configuración |
| `main.tf` | Invocación del módulo con `local.*` transformados |
| `outputs.tf` | Outputs para validar la infraestructura creada |
| `providers.tf` | Configuración del provider con `default_tags` |
