# Each integration depends_on the two charm modules it relates (#18). Integrations are not
# chained to each other. 

# Temporal Frontend ↔ PostgreSQL
resource "juju_integration" "frontend_to_postgresql" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-frontend"
    endpoint = module.temporal_frontend.requires.db
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
  depends_on = [module.temporal_frontend, module.postgresql]
}

# Temporal Frontend ↔ PostgreSQL (visibility)
resource "juju_integration" "frontend_visibility_to_postgresql" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-frontend"
    endpoint = module.temporal_frontend.requires.visibility
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
  depends_on = [module.temporal_frontend, module.postgresql]
}

# Temporal History ↔ PostgreSQL
resource "juju_integration" "history_to_postgresql" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-history"
    endpoint = module.temporal_history.requires.db
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
  depends_on = [module.temporal_history, module.postgresql]
}

# Temporal Matching ↔ PostgreSQL
resource "juju_integration" "matching_to_postgresql" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-matching"
    endpoint = module.temporal_matching.requires.db
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
  depends_on = [module.temporal_matching, module.postgresql]
}

# Temporal History ↔ PostgreSQL (visibility)
resource "juju_integration" "history_visibility_to_postgresql" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-history"
    endpoint = module.temporal_history.requires.visibility
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
  depends_on = [module.temporal_history, module.postgresql]
}

# Temporal Matching ↔ PostgreSQL (visibility)
resource "juju_integration" "matching_visibility_to_postgresql" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-matching"
    endpoint = module.temporal_matching.requires.visibility
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
  depends_on = [module.temporal_matching, module.postgresql]
}

# Temporal Worker ↔ PostgreSQL
resource "juju_integration" "worker_to_postgresql" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-worker"
    endpoint = module.temporal_worker.requires.db
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
  depends_on = [module.temporal_worker, module.postgresql]
}

# Temporal Worker ↔ PostgreSQL (visibility)
resource "juju_integration" "worker_visibility_to_postgresql" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-worker"
    endpoint = module.temporal_worker.requires.visibility
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
  depends_on = [module.temporal_worker, module.postgresql]
}

# Temporal Frontend ↔ UI
resource "juju_integration" "frontend_to_ui" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-frontend"
    endpoint = module.temporal_frontend.requires.ui
  }
  application {
    name     = var.temporal_ui.app_name
    endpoint = module.temporal_ui.provides.ui
  }
  depends_on = [module.temporal_frontend, module.temporal_ui]
}

# Temporal Frontend ↔ Admin
resource "juju_integration" "frontend_to_admin" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-frontend"
    endpoint = module.temporal_frontend.requires.admin
  }
  application {
    name     = var.temporal_admin.app_name
    endpoint = module.temporal_admin.provides.admin
  }
  depends_on = [module.temporal_frontend, module.temporal_admin]
}

# Temporal Admin ↔ Temporal History
resource "juju_integration" "admin_to_history" {
  model_uuid = var.model_uuid
  application {
    name     = var.temporal_admin.app_name
    endpoint = module.temporal_admin.provides.admin
  }
  application {
    name     = "temporal-history"
    endpoint = module.temporal_history.requires.admin
  }
  depends_on = [module.temporal_admin, module.temporal_history]
}

# Temporal Admin ↔ Temporal Matching
resource "juju_integration" "admin_to_matching" {
  model_uuid = var.model_uuid
  application {
    name     = var.temporal_admin.app_name
    endpoint = module.temporal_admin.provides.admin
  }
  application {
    name     = "temporal-matching"
    endpoint = module.temporal_matching.requires.admin
  }
  depends_on = [module.temporal_admin, module.temporal_matching]
}

# Temporal Admin ↔ Temporal Worker
resource "juju_integration" "admin_to_worker" {
  model_uuid = var.model_uuid
  application {
    name     = var.temporal_admin.app_name
    endpoint = module.temporal_admin.provides.admin
  }
  application {
    name     = "temporal-worker"
    endpoint = module.temporal_worker.requires.admin
  }
  depends_on = [module.temporal_admin, module.temporal_worker]
}
