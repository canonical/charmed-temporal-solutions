module "postgresql" {
  # tflint-ignore: terraform_module_pinned_source 16/edge.
  # TODO: update ref to stable hash, currently it points to 1
  source     = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=c5b1378aea463ef9922bd11d1778bb5ca7ed5114"
  juju_model = var.model_uuid
  app_name   = var.postgresql.app_name
  channel    = var.postgresql.channel
  units      = var.postgresql.units
  config     = var.postgresql.config
}

module "temporal_frontend" {
  source     = "git::https://github.com/canonical/temporal-k8s-operator//terraform?ref=track/1.23"
  model_uuid = var.model_uuid
  app_name   = "temporal-frontend"
  channel    = var.temporal_server.channel
  units      = var.temporal_server.units
  config     = var.temporal_server.config
}

module "temporal_history" {
  source     = "git::https://github.com/canonical/temporal-k8s-operator//terraform?ref=track/1.23"
  model_uuid = var.model_uuid
  app_name   = "temporal-history"
  channel    = var.temporal_server.channel
  units      = var.temporal_server.units
  config     = var.temporal_server.config
}

module "temporal_matching" {
  source     = "git::https://github.com/canonical/temporal-k8s-operator//terraform?ref=track/1.23"
  model_uuid = var.model_uuid
  app_name   = "temporal-matching"
  channel    = var.temporal_server.channel
  units      = var.temporal_server.units
  config     = var.temporal_server.config
}

module "temporal_worker" {
  source     = "git::https://github.com/canonical/temporal-k8s-operator//terraform?ref=track/1.23"
  model_uuid = var.model_uuid
  app_name   = "temporal-worker"
  channel    = var.temporal_server.channel
  units      = var.temporal_server.units
  config     = var.temporal_server.config
}

module "temporal_ui" {
  source     = "git::https://github.com/canonical/temporal-ui-k8s-operator//terraform?ref=track/1.23"
  model_uuid = var.model_uuid
  app_name   = var.temporal_ui.app_name
  channel    = var.temporal_ui.channel
  units      = var.temporal_ui.units
  config     = var.temporal_ui.config
}

module "temporal_admin" {
  source     = "git::https://github.com/canonical/temporal-admin-k8s-operator//terraform?ref=track/1.23"
  model_uuid = var.model_uuid
  app_name   = var.temporal_admin.app_name
  channel    = var.temporal_admin.channel
  units      = var.temporal_admin.units
  config     = var.temporal_admin.config
}
