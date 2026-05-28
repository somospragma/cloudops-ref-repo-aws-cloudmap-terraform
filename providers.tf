# PC-IAC-005: Providers - Configuración y Alias
# El provider es inyectado desde el Módulo Raíz (IaC Root) mediante el alias aws.project.
# Este módulo NO configura el provider directamente; lo consume a través del alias.
# La configuración completa del provider (region, assume_role, default_tags) reside en el Root.
