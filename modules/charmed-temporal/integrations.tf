# Temporal Frontend ↔ PostgreSQL
resource "juju_integration" "frontend_to_postgresql" {
  model = var.model
  application {
    name     = "temporal-frontend"
    endpoint = module.temporal_frontend.requires.db
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
}

# Temporal Frontend ↔ PostgreSQL (visibility)
resource "juju_integration" "frontend_visibility_to_postgresql" {
  model = var.model
  application {
    name     = "temporal-frontend"
    endpoint = module.temporal_frontend.requires.visibility
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
}

# Temporal Frontend ↔ UI
resource "juju_integration" "frontend_to_ui" {
  model = var.model
  application {
    name     = "temporal-frontend"
    endpoint = module.temporal_frontend.requires.ui
  }
  application {
    name     = var.temporal_ui.app_name
    endpoint = module.temporal_ui.provides.ui
  }
}

# Temporal Frontend ↔ Admin
resource "juju_integration" "frontend_to_admin" {
  model = var.model
  application {
    name     = "temporal-frontend"
    endpoint = module.temporal_frontend.requires.admin
  }
  application {
    name     = var.temporal_admin.app_name
    endpoint = module.temporal_admin.provides.admin
  }
}
# Temporal History ↔ PostgreSQL
resource "juju_integration" "history_to_postgresql" {
  model = var.model
  application {
    name     = "temporal-history"
    endpoint = module.temporal_history.requires.db
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
}

# Temporal Matching ↔ PostgreSQL
resource "juju_integration" "matching_to_postgresql" {
  model = var.model
  application {
    name     = "temporal-matching"
    endpoint = module.temporal_matching.requires.db
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
}

# Temporal History ↔ PostgreSQL (visibility)
resource "juju_integration" "history_visibility_to_postgresql" {
  model = var.model
  application {
    name     = "temporal-history"
    endpoint = module.temporal_history.requires.visibility
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
}

# Temporal Matching ↔ PostgreSQL (visibility)
resource "juju_integration" "matching_visibility_to_postgresql" {
  model = var.model
  application {
    name     = "temporal-matching"
    endpoint = module.temporal_matching.requires.visibility
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
}

# Temporal Admin ↔ Temporal History
resource "juju_integration" "admin_to_history" {
  model = var.model
  application {
    name     = var.temporal_admin.app_name
    endpoint = module.temporal_admin.provides.admin
  }
  application {
    name     = "temporal-history"
    endpoint = module.temporal_history.requires.admin
  }
}

# Temporal Admin ↔ Temporal Matching
resource "juju_integration" "admin_to_matching" {
  model = var.model
  application {
    name     = var.temporal_admin.app_name
    endpoint = module.temporal_admin.provides.admin
  }
  application {
    name     = "temporal-matching"
    endpoint = module.temporal_matching.requires.admin
  }
}

# Temporal Worker ↔ PostgreSQL
resource "juju_integration" "worker_to_postgresql" {
  model = var.model
  application {
    name     = "temporal-worker"
    endpoint = module.temporal_worker.requires.db
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
}

# Temporal Worker ↔ PostgreSQL (visibility)
resource "juju_integration" "worker_visibility_to_postgresql" {
  model = var.model
  application {
    name     = "temporal-worker"
    endpoint = module.temporal_worker.requires.visibility
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
}

# Temporal Admin ↔ Temporal Worker
resource "juju_integration" "admin_to_worker" {
  model = var.model
  application {
    name     = var.temporal_admin.app_name
    endpoint = module.temporal_admin.provides.admin
  }
  application {
    name     = "temporal-worker"
    endpoint = module.temporal_worker.requires.admin
  }
}
