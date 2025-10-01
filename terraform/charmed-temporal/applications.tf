
locals {
  app_names = {
    postgresql     = module.postgresql.application_name
    temporal       = module.temporal_server.app_name
    temporal_ui    = module.temporal_ui.app_name
    temporal_admin = module.temporal_admin.app_name
  }

  provides = {
    postgresql     = module.postgresql.provides
    temporal       = module.temporal_server.provides
    temporal_ui    = module.temporal_ui.provides
    temporal_admin = module.temporal_admin.provides
  }

  requires = {
    postgresql     = module.postgresql.requires
    temporal       = module.temporal_server.requires
    temporal_ui    = module.temporal_ui.requires
  }
}
