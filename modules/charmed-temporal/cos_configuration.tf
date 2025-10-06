# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  cos_enabled             = var.cos_configuration
  grafana_agent_app_name  = "grafana-agent"
}

# Deploy grafana-agent-k8s using juju_application if COS is enabled
resource "juju_application" "grafana_agent_k8s" {
  count = local.cos_enabled && var.existing_grafana_agent_name == null ? 1 : 0

  name      = local.grafana_agent_app_name
  model     = var.model
  charm     = "grafana-agent-k8s"
  channel   = "1/stable"
  trust     = true
  units     = 1
  config    = {}
}

# Resolve the name of grafana-agent (existing or newly deployed)
locals {
  grafana_agent_resolved_name = local.cos_enabled ? (
    var.existing_grafana_agent_name != null
      ? var.existing_grafana_agent_name
      : juju_application.grafana_agent_k8s[0].name
  ) : null
}

# Integration: Grafana Agent <-> Temporal (metrics)
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

# Integration: Grafana Agent <-> Temporal (dashboards)
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
