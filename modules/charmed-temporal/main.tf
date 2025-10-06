module "postgresql" {
  source          = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=main"
  juju_model_name = var.model

  app_name = var.postgresql.app_name
  channel  = var.postgresql.channel
  revision = var.postgresql.revision
  units    = var.postgresql.units
  config   = var.postgresql.config
}

module "temporal_server" {
  source = "git::https://github.com/canonical/temporal-k8s-operator//terraform?ref=track/1.23"
  model  = var.model

  app_name = var.temporal_server.app_name
  channel  = var.temporal_server.channel
  revision = var.temporal_server.revision
  units    = var.temporal_server.units
  config   = var.temporal_server.config
}

module "temporal_ui" {
  source = "git::https://github.com/canonical/temporal-ui-k8s-operator//terraform?ref=track/1.23"
  model  = var.model

  app_name = var.temporal_ui.app_name
  channel  = var.temporal_ui.channel
  revision = var.temporal_ui.revision
  units    = var.temporal_ui.units
  config   = var.temporal_ui.config
}

module "temporal_admin" {
  source = "git::https://github.com/canonical/temporal-admin-k8s-operator//terraform?ref=track/1.23"
  model  = var.model

  app_name = var.temporal_admin.app_name
  channel  = var.temporal_admin.channel
  revision = var.temporal_admin.revision
  units    = var.temporal_admin.units
  config   = var.temporal_admin.config
}
