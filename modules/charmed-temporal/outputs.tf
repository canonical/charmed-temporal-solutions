
output "applications" {
  description = "All charm modules which make up this product module."
  value = {
    postgresql     = module.postgresql
    temporal       = module.temporal_server
    temporal_ui    = module.temporal_ui
    temporal_admin = module.temporal_admin
  }
}

# Requirers exposed by Temporal Server
output "frontend_certificates_requirer" {
  description = "Map containing the app_name and the requires of the TLS requirer charm."
  value = {
    app_name = local.app_names.temporal
    requires = local.requires.temporal.frontend_certificates
  }
}

output "server_nginx_route_requirer" {
  description = "Map containing the app_name and the requires of the nginx route requirer charm (server)."
  value = {
    app_name = local.app_names.temporal
    requires = local.requires.temporal.nginx_route
  }
}

# Requirers exposed by Temporal UI
output "ui_nginx_route_requirer" {
  description = "Map containing the app_name and the requires of the nginx route requirer charm (UI)."
  value = {
    app_name = local.app_names.temporal_ui
    requires = local.requires.temporal_ui.nginx_route
  }
}

# OpenFGA integration (from Temporal Server)
output "openfga_requirer" {
  description = "Map containing the app_name and the requires of the OpenFGA requirer charm."
  value = {
    app_name = local.app_names.temporal
    requires = local.requires.temporal.openfga
  }
}

# Grafana Agent (only if cos_configuration = true)
output "grafana_agent_k8s" {
  description = "grafana-agent-k8s application name when COS is enabled."
  value = var.cos_configuration ? {
    app_name = local.grafana_agent_resolved_name
  } : {}
}

# S3 Integrator (from Temporal Server)
output "s3_integrator_requirer" {
  description = "Map containing the app_name and the requires of the s3 integrator requirer charm."
  value = {
    app_name = local.app_names.temporal
    requires = local.requires.temporal.s3_paramaters
  }
}
