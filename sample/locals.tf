# PC-IAC-026: Patrón de Transformación - locals.tf inyecta IDs dinámicos
# PC-IAC-009: Lógica de inyección exclusiva en locals.tf
# PC-IAC-021: Centralización de configuración compleja en locals.tf
# PC-IAC-025: Procesamiento de gobernanza en el Root

locals {
  # ─── Transformación de Namespaces (PC-IAC-026) ───────────────────────────
  # Inyecta el vpc_id dinámico desde el data source para namespaces DNS_PRIVATE.
  # Si el usuario ya proveyó un vpc_id en tfvars, se respeta; de lo contrario
  # se usa el ID obtenido del data source (PC-IAC-009).
  namespaces_transformed = {
    for key, config in var.namespaces : key => merge(config, {
      vpc_id = (
        config.type == "DNS_PRIVATE"
        ? (length(try(config.vpc_id, "")) > 0 ? config.vpc_id : data.aws_vpc.selected.id)
        : config.vpc_id
      )
    })
  }
}
