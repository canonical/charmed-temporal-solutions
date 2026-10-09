# Base vars for CI / local `just test`. `validate_test_tfvars` appends `model_uuid`.
temporal_server = {
    channel = "1.31/edge"
    config = {
     num-history-shards         = "1"
     persistence-max-conns      = "6"
     persistence-max-idle-conns = "4"
     visibility-max-conns       = "3"
     visibility-max-idle-conns  = "2"
   }
}

temporal_admin = {
  channel = "1.31/edge"
}

temporal_ui = {
  channel = "1.31/edge"
}

pgbouncer = {
    config = {
     max_db_connections = "25"
   }
}

postgresql = {
    config = {
     profile = "testing"
   }
}
