# Base vars for CI / local `just test`. `validate_test_tfvars` appends `model_uuid`.
postgresql = {
  config = {
    profile = "testing"
  }
}
