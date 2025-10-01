terraform {
  required_version = ">= 1.3.0"

  required_providers {
    juju = {
      source  = "juju/juju"
      version = ">= 0.23.0"
    }
  }
}
