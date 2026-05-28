# Changelog

Todos los cambios notables de este módulo serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-05-28

### Added
- Estructura inicial del módulo siguiendo las 26 reglas de gobernanza PC-IAC.
- Soporte para namespaces HTTP (`aws_service_discovery_http_namespace`).
- Soporte para namespaces DNS Privados (`aws_service_discovery_private_dns_namespace`).
- Soporte para namespaces DNS Públicos (`aws_service_discovery_public_dns_namespace`).
- Directorio `sample/` con ejemplo funcional completo siguiendo el patrón PC-IAC-026.
- Archivo `versions.tf` con pinning de providers y alias `aws.project` (PC-IAC-005, PC-IAC-006).
- Archivo `data.tf` con comentario de restricción de Data Sources (PC-IAC-011).
- Nomenclatura estándar `{client}-{project}-{environment}-ns-{key}` en `locals.tf` (PC-IAC-003).
- Outputs granulares con Splat Expressions (PC-IAC-007, PC-IAC-014).
- Variables con validaciones y tipos explícitos (PC-IAC-002).
