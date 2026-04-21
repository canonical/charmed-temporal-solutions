# Each integration depends_on the two charm modules/resources it relates.
# Temporal services connect to PostgreSQL through PgBouncer (session pooling mode by default),

# PgBouncer ↔ PostgreSQL (backend)
resource "juju_integration" "pgbouncer_to_postgresql" {
  model_uuid = var.model_uuid
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
  application {
    name     = juju_application.pgbouncer.name
    endpoint = "backend-database"
  }
  depends_on = [module.postgresql, juju_application.pgbouncer]
}

# Temporal Frontend ↔ PgBouncer
resource "juju_integration" "frontend_to_pgbouncer" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-frontend"
    endpoint = module.temporal_frontend.requires.db
  }
  application {
    name     = juju_application.pgbouncer.name
    endpoint = "database"
  }
  depends_on = [module.temporal_frontend, juju_application.pgbouncer]
}

# Temporal Frontend ↔ PgBouncer (visibility)
resource "juju_integration" "frontend_visibility_to_pgbouncer" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-frontend"
    endpoint = module.temporal_frontend.requires.visibility
  }
  application {
    name     = juju_application.pgbouncer.name
    endpoint = "database"
  }
  depends_on = [module.temporal_frontend, juju_application.pgbouncer]
}

# Temporal History ↔ PgBouncer
resource "juju_integration" "history_to_pgbouncer" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-history"
    endpoint = module.temporal_history.requires.db
  }
  application {
    name     = juju_application.pgbouncer.name
    endpoint = "database"
  }
  depends_on = [module.temporal_history, juju_application.pgbouncer]
}

# Temporal History ↔ PgBouncer (visibility)
resource "juju_integration" "history_visibility_to_pgbouncer" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-history"
    endpoint = module.temporal_history.requires.visibility
  }
  application {
    name     = juju_application.pgbouncer.name
    endpoint = "database"
  }
  depends_on = [module.temporal_history, juju_application.pgbouncer]
}

# Temporal Matching ↔ PgBouncer
resource "juju_integration" "matching_to_pgbouncer" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-matching"
    endpoint = module.temporal_matching.requires.db
  }
  application {
    name     = juju_application.pgbouncer.name
    endpoint = "database"
  }
  depends_on = [module.temporal_matching, juju_application.pgbouncer]
}

# Temporal Matching ↔ PgBouncer (visibility)
resource "juju_integration" "matching_visibility_to_pgbouncer" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-matching"
    endpoint = module.temporal_matching.requires.visibility
  }
  application {
    name     = juju_application.pgbouncer.name
    endpoint = "database"
  }
  depends_on = [module.temporal_matching, juju_application.pgbouncer]
}

# Temporal Worker ↔ PgBouncer
resource "juju_integration" "worker_to_pgbouncer" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-worker"
    endpoint = module.temporal_worker.requires.db
  }
  application {
    name     = juju_application.pgbouncer.name
    endpoint = "database"
  }
  depends_on = [module.temporal_worker, juju_application.pgbouncer]
}

# Temporal Worker ↔ PgBouncer (visibility)
resource "juju_integration" "worker_visibility_to_pgbouncer" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-worker"
    endpoint = module.temporal_worker.requires.visibility
  }
  application {
    name     = juju_application.pgbouncer.name
    endpoint = "database"
  }
  depends_on = [module.temporal_worker, juju_application.pgbouncer]
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

# Temporal Frontent ↔ UI (temporal-host-info)
resource "juju_integration" "frontend_to_ui_host_info"{
  model_uuid = var.model_uuid
  application {
    name     = "temporal-frontend"
    endpoint = "temporal-host-info"
  }
  application {
    name     = var.temporal_ui.app_name
    endpoint = "temporal-host-info"
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

# Temporal Frontend ↔ Admin (temporal-host-info)
resource "juju_integration" "frontend_to_admin_host_info" {
  model_uuid = var.model_uuid
  application {
    name     = "temporal-frontend"
    endpoint = "temporal-host-info"
  }
  application {
    name     = var.temporal_admin.app_name
    endpoint = "temporal-host-info"
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
