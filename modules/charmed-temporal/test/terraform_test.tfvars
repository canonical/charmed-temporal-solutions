# Base vars for CI / local `just test`. `validate_test_tfvars` appends `model_uuid`.
temporal_server = {
    config = {
     num-history-shards         = "1"
     persistence-max-conns      = "6"
     persistence-max-idle-conns = "4"
     visibility-max-conns       = "3"
     visibility-max-idle-conns  = "2"
   }
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
