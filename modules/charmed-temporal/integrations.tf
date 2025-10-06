# Temporal ↔ PostgreSQL (main DB)
resource "juju_integration" "temporal_to_postgresql" {
  model = var.model

  application {
    name     = local.app_names.temporal
    endpoint = local.requires.temporal.db
  }

  application {
    name     = local.app_names.postgresql
    endpoint = local.provides.postgresql.database
  }
}

# Temporal ↔ PostgreSQL (visibility DB)
resource "juju_integration" "temporal_visibility_to_postgresql" {
  model = var.model

  application {
    name     = local.app_names.temporal
    endpoint = local.requires.temporal.visibility
  }

  application {
    name     = local.app_names.postgresql
    endpoint = local.provides.postgresql.database
  }
}

# Temporal ↔ UI
resource "juju_integration" "temporal_to_ui" {
  model = var.model

  application {
    name     = local.app_names.temporal
    endpoint = local.requires.temporal.ui
  }

  application {
    name     = local.app_names.temporal_ui
    endpoint = local.provides.temporal_ui.ui
  }
}

# Temporal ↔ Admin
resource "juju_integration" "temporal_to_admin" {
  model = var.model

  application {
    name     = local.app_names.temporal
    endpoint = local.requires.temporal.admin
  }

  application {
    name     = local.app_names.temporal_admin
    endpoint = local.provides.temporal_admin.admin
  }
}
