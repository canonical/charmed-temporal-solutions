# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  cos_enabled            = var.cos_configuration
  grafana_agent_app_name = "grafana-agent"

  # Application names come from variables (not submodule outputs)
  app_names = {
    postgresql     = var.postgresql.app_name
    temporal       = var.temporal_server.app_name
    temporal_ui    = var.temporal_ui.app_name
    temporal_admin = var.temporal_admin.app_name
  }

  # Define what each charm "requires" — these map to integration endpoints
  requires = {
    temporal = {
      db                    = module.temporal_server.requires.db
      visibility            = module.temporal_server.requires.visibility
      ui                    = module.temporal_server.requires.ui
      admin                 = module.temporal_server.requires.admin
      frontend_certificates = try(module.temporal_server.requires.frontend_certificates, null)
      nginx_route           = try(module.temporal_server.requires.nginx_route, null)
      openfga               = try(module.temporal_server.requires.openfga, null)
      s3_paramaters         = try(module.temporal_server.requires.s3_paramaters, null)
    }

    temporal_ui = {
      nginx_route = try(module.temporal_ui.requires.nginx_route, null)
    }
  }

  # Define what each charm "provides" — for connections/integrations
  provides = {
    postgresql     = module.postgresql.provides
    temporal_ui    = module.temporal_ui.provides
    temporal_admin = module.temporal_admin.provides
    temporal       = try(module.temporal_server.provides, {})
  }
}

# Deploy grafana-agent-k8s if COS is enabled
resource "juju_application" "grafana_agent_k8s" {
  count = local.cos_enabled && var.existing_grafana_agent_name == null ? 1 : 0

  name  = local.grafana_agent_app_name
  model = var.model

  charm {
    name    = "grafana-agent-k8s"
    channel = "1/stable"
  }

  trust  = true
  units  = 1
  config = {}
}

# Resolve grafana-agent name (either existing or newly deployed)
locals {
  grafana_agent_resolved_name = local.cos_enabled ? (
    var.existing_grafana_agent_name != null
    ? var.existing_grafana_agent_name
    : juju_application.grafana_agent_k8s[0].name
  ) : null
}

# -------------------------------
# Integrations
# -------------------------------

# Grafana Agent ↔ Temporal (metrics)
resource "juju_integration" "grafana_agent_to_temporal" {
  count = local.cos_enabled ? 1 : 0
  model = var.model

  application {
    name     = local.grafana_agent_resolved_name
    endpoint = "metrics-endpoint"
  }

  application {
    name     = local.app_names.temporal
    endpoint = local.provides.temporal.metrics_endpoint
  }
}

# Grafana Agent ↔ Temporal (dashboards)
resource "juju_integration" "grafana_dashboard_to_temporal" {
  count = local.cos_enabled ? 1 : 0
  model = var.model

  application {
    name     = local.grafana_agent_resolved_name
    endpoint = "grafana-dashboard"
  }

  application {
    name     = local.app_names.temporal
    endpoint = local.provides.temporal.grafana_dashboard
  }
}
