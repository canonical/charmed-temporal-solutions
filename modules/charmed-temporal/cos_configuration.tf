locals {
  cos_enabled            = var.cos_configuration
  grafana_agent_app_name = "grafana-agent"
  app_names = {
    postgresql     = var.postgresql.app_name
    temporal_front = "temporal-frontend"
    temporal_hist  = "temporal-history"
    temporal_match = "temporal-matching"
    temporal_work  = "temporal-worker"
    temporal_ui    = var.temporal_ui.app_name
    temporal_admin = var.temporal_admin.app_name
  }

  provides = {
    postgresql     = module.postgresql.provides
    temporal_front = module.temporal_frontend.provides
    temporal_hist  = module.temporal_history.provides
    temporal_match = module.temporal_matching.provides
    temporal_work  = module.temporal_worker.provides
    temporal_ui    = module.temporal_ui.provides
    temporal_admin = module.temporal_admin.provides
  }
}

resource "juju_application" "grafana_agent_k8s" {
  count = local.cos_enabled && var.existing_grafana_agent_name == null ? 1 : 0
  name  = local.grafana_agent_app_name
  model_uuid = var.model_uuid
  charm {
    name    = "grafana-agent-k8s"
    channel = "1/stable"
  }
  trust  = true
  units  = 1
  config = {}
}

locals {
  grafana_agent_resolved_name = local.cos_enabled ? (
    var.existing_grafana_agent_name != null
    ? var.existing_grafana_agent_name
    : juju_application.grafana_agent_k8s[0].name
  ) : null
}

# COS integrations for Temporal frontend, history, and matching
resource "juju_integration" "grafana_to_temporal_frontend" {
  count = local.cos_enabled ? 1 : 0
  model_uuid = var.model_uuid
  application {
    name     = local.grafana_agent_resolved_name
    endpoint = "metrics-endpoint"
  }
  application {
    name     = local.app_names.temporal_front
    endpoint = local.provides.temporal_front.metrics_endpoint
  }
}

resource "juju_integration" "grafana_to_temporal_history" {
  count = local.cos_enabled ? 1 : 0
  model_uuid = var.model_uuid
  application {
    name     = local.grafana_agent_resolved_name
    endpoint = "metrics-endpoint"
  }
  application {
    name     = local.app_names.temporal_hist
    endpoint = local.provides.temporal_hist.metrics_endpoint
  }
}

resource "juju_integration" "grafana_to_temporal_matching" {
  count = local.cos_enabled ? 1 : 0
  model_uuid = var.model_uuid
  application {
    name     = local.grafana_agent_resolved_name
    endpoint = "metrics-endpoint"
  }
  application {
    name     = local.app_names.temporal_match
    endpoint = local.provides.temporal_match.metrics_endpoint
  }
}

resource "juju_integration" "grafana_to_temporal_worker" {
  count = local.cos_enabled ? 1 : 0
  model_uuid = var.model_uuid
  application {
    name     = local.grafana_agent_resolved_name
    endpoint = "metrics-endpoint"
  }
  application {
    name     = local.app_names.temporal_work
    endpoint = local.provides.temporal_work.metrics_endpoint
  }
}
