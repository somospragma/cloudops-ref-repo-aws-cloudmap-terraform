# cloudops-ref-repo-aws-cloudmap-terraform

Módulo de referencia Terraform para gestionar namespaces de **AWS Cloud Map** (Service Discovery). Soporta los tres tipos de namespace: HTTP, DNS Privado y DNS Público.

---

## Descripción

AWS Cloud Map es un servicio de descubrimiento de servicios en la nube que permite registrar recursos de aplicación (instancias EC2, contenedores ECS, funciones Lambda, etc.) con nombres personalizados y consultar su ubicación en tiempo de ejecución.

Este módulo crea y gestiona:
- **Namespaces HTTP** (`aws_service_discovery_http_namespace`)
- **Namespaces DNS Privados** (`aws_service_discovery_private_dns_namespace`)
- **Namespaces DNS Públicos** (`aws_service_discovery_public_dns_namespace`)

---

## Uso

```hcl
module "cloudmap" {
  source = "git::https://github.com/somospragma/cloudops-ref-repo-aws-cloudmap-terraform.git?ref=v1.0.0"

  providers = {
    aws.project = aws.principal
  }

  # C. Variables de Gobernanza (PC-IAC-013)
  client      = var.client
  project     = var.project
  environment = var.environment

  # E. Variables de Configuración
  namespaces = local.namespaces_transformed
}
```

---

## Inputs

| Nombre | Descripción | Tipo | Requerido | Default |
|--------|-------------|------|-----------|---------|
| `client` | Nombre del cliente para nomenclatura estándar | `string` | ✅ | - |
| `project` | Nombre del proyecto para nomenclatura estándar | `string` | ✅ | - |
| `environment` | Entorno de despliegue (`dev`, `qa`, `pdn`) | `string` | ✅ | - |
| `namespaces` | Mapa de configuración de namespaces Cloud Map | `map(object)` | No | `{}` |

### Estructura de `namespaces`

| Campo | Descripción | Tipo | Default |
|-------|-------------|------|---------|
| `description` | Descripción del namespace | `string` | `""` |
| `type` | Tipo de namespace: `HTTP`, `DNS_PRIVATE`, `DNS_PUBLIC` | `string` | `"HTTP"` |
| `vpc_id` | ID de la VPC (obligatorio para `DNS_PRIVATE`) | `string` | `null` |
| `services` | Mapa de servicios dentro del namespace | `map(object)` | `{}` |
| `additional_tags` | Etiquetas adicionales para el namespace | `map(string)` | `{}` |

---

## Outputs

| Nombre | Descripción |
|--------|-------------|
| `http_namespace_ids` | Mapa de IDs de namespaces HTTP |
| `http_namespace_arns` | Mapa de ARNs de namespaces HTTP |
| `private_dns_namespace_ids` | Mapa de IDs de namespaces DNS privados |
| `private_dns_namespace_arns` | Mapa de ARNs de namespaces DNS privados |
| `public_dns_namespace_ids` | Mapa de IDs de namespaces DNS públicos |
| `public_dns_namespace_arns` | Mapa de ARNs de namespaces DNS públicos |
| `all_namespace_ids` | Mapa consolidado de IDs de todos los namespaces |
| `all_namespace_arns` | Mapa consolidado de ARNs de todos los namespaces |

---

## Requisitos

| Herramienta | Versión mínima |
|-------------|----------------|
| Terraform | `>= 1.0.0` |
| AWS Provider | `>= 4.31.0` |

---

## Cumplimiento PC-IAC

| Regla | Descripción | Implementación |
|-------|-------------|----------------|
| PC-IAC-001 | Estructura de Módulo | 10 archivos raíz + 8 archivos en `sample/` |
| PC-IAC-002 | Variables | `type`, `description` y `validation` en todas las variables |
| PC-IAC-003 | Nomenclatura Estándar | Patrón `{client}-{project}-{environment}-ns-{key}` en `locals.tf` |
| PC-IAC-004 | Etiquetas (Tagging) | `tags = merge({ Name = ... }, additional_tags)` en cada recurso |
| PC-IAC-005 | Providers | `provider = aws.project` en cada recurso; `configuration_aliases` en `versions.tf` |
| PC-IAC-006 | Versiones | `required_version >= 1.0.0`; provider `>= 4.31.0` en `versions.tf` |
| PC-IAC-007 | Outputs | Outputs granulares (IDs y ARNs); sin objetos completos |
| PC-IAC-010 | For_Each | `for_each` con filtro por tipo en todos los recursos |
| PC-IAC-011 | Data Sources | Prohibidos en el módulo; `data.tf` con comentario explicativo |
| PC-IAC-023 | Responsabilidad Única | Solo recursos intrínsecos de Cloud Map; sin IAM, VPC ni SG |

---

## Decisiones de Diseño

### Separación por tipo de namespace
Se usan tres bloques `resource` separados (uno por tipo) en lugar de un único recurso con `count`, ya que cada tipo tiene atributos distintos (`vpc` solo en DNS_PRIVATE). Esto mantiene el código legible y evita condicionales complejos dentro del recurso.

### vpc_id como variable de entrada
El `vpc_id` para namespaces DNS_PRIVATE debe ser inyectado desde el Módulo Raíz a través de un Data Source (`data.aws_vpc`). El módulo no crea ni busca la VPC (PC-IAC-023, PC-IAC-011).

### Nomenclatura automática
El nombre del namespace se construye automáticamente como `{client}-{project}-{environment}-ns-{key}`. No se expone un campo `name` libre para garantizar la consistencia de la nomenclatura estándar (PC-IAC-003).

---

## Ejemplo de Uso Completo

Ver el directorio [`sample/`](./sample/README.md) para un ejemplo funcional completo.
