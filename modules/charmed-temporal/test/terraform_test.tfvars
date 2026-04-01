# Base vars for CI / local `just test`. `validate_test_tfvars` appends `model_uuid`.
# Higher PostgreSQL connection headroom (postgresql-k8s charm).
postgresql = {
  config = {
    profile = "testing"
  }
}
