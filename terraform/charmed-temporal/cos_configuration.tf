
locals {
  cos_enabled = var.cos_configuration
}

# Deploy grafana-agent if enabled and no existing one is provided
module "grafana_agent" {
  count  = local.cos_enabled && var.existing_grafana_agent_name == null ? 1 : 0
  source = "git::https://github.com/canonical/grafana-agent-k8s-operator//terraform?ref=main"
  model  = var.model

  app_name = "grafana-agent"
  channel  = "latest/stable"
  revision = 0
  units    = 1
  config   = {}
}

locals {
  grafana_agent_app_name = local.cos_enabled ? (
    var.existing_grafana_agent_name != null
      ? var.existing_grafana_agent_name
      : module.grafana_agent[0].app_name
  ) : null
}

# Integrations between Grafana agent and Temporal Server
resource "juju_integration" "grafana_agent_to_temporal" {
  count = local.cos_enabled ? 1 : 0
  model = var.model

  application {
    name     = local.grafana_agent_app_name
    endpoint = "send-remote-write"
  }

  application {
    name     = local.app_names.temporal
    endpoint = local.provides.temporal.metrics_endpoint
  }
}

resource "juju_integration" "grafana_dashboard_to_temporal" {
  count = local.cos_enabled ? 1 : 0
  model = var.model

  application {
    name     = local.grafana_agent_app_name
    endpoint = "grafana-dashboard"
  }

  application {
    name     = local.app_names.temporal
    endpoint = local.provides.temporal.grafana_dashboard
  }
}

