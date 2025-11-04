output "applications" {
  description = "All charm modules which make up this product module."
  value = {
    postgresql = module.postgresql
    temporal = {
      frontend = module.temporal_frontend
      history  = module.temporal_history
      matching = module.temporal_matching
      worker   = module.temporal_worker
    }
    temporal_ui    = module.temporal_ui
    temporal_admin = module.temporal_admin
  }
}

# Requirers exposed by Temporal services
output "frontend_certificates_requirer" {
  description = "Map containing the app_name and the requires of the TLS requirer charm (frontend)."
  value = {
    app_name = "temporal-frontend"
    requires = module.temporal_frontend.requires.frontend_certificates
  }
}

output "server_nginx_route_requirer" {
  description = "Map containing the app_name and the requires of the nginx route requirer charm (frontend)."
  value = {
    app_name = "temporal-frontend"
    requires = module.temporal_frontend.requires.nginx_route
  }
}

# Requirers exposed by Temporal UI
output "ui_nginx_route_requirer" {
  description = "Map containing the app_name and the requires of the nginx route requirer charm (UI)."
  value = {
    app_name = var.temporal_ui.app_name
    requires = module.temporal_ui.requires.nginx_route
  }
}

# OpenFGA integration (from Temporal Frontend)
output "openfga_requirer" {
  description = "Map containing the app_name and the requires of the OpenFGA requirer charm."
  value = {
    app_name = "temporal-frontend"
    requires = module.temporal_frontend.requires.openfga
  }
}

# Grafana Agent (only if cos_configuration = true)
output "grafana_agent_k8s" {
  description = "grafana-agent-k8s application name when COS is enabled."
  value = var.cos_configuration ? {
    app_name = local.grafana_agent_resolved_name
    app = module.grafana_agent_k8s
  } : {}
}

# S3 Integrator (from Temporal Frontend)
output "s3_integrator_requirer" {
  description = "Map containing the app_name and the requires of the s3 integrator requirer charm."
  value = {
    app_name = "temporal-frontend"
    requires = module.temporal_frontend.requires.s3_paramaters
  }
}
