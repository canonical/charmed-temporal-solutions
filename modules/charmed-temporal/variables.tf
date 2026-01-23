variable "model_uuid" {
  description = "UUID of the juju model to deploy to."
  type        = string
}

variable "temporal_server" {
  description = "Inputs for temporal-k8s charm module."
  type = object({
    app_name = optional(string, "temporal-server")
    channel  = optional(string, "1.23/edge")
    revision = optional(number, 0)
    units    = optional(number, 1)
    config   = optional(map(string), { num-history-shards = "1" })
  })
  default = {}
}

variable "postgresql" {
  description = "Inputs for postgresql-k8s charm module."
  type = object({
    app_name = optional(string, "postgres")
    # TODO: Update channel whenever 16/stable is released. Related issue https://github.com/canonical/charmed-temporal-solutions/issues/12
    channel  = optional(string, "16/edge")
    revision = optional(number, 0)
    units    = optional(number, 1)
    config   = optional(map(string), {})
  })
  default = {}
}

variable "temporal_ui" {
  description = "Inputs for temporal-ui-k8s charm module."
  type = object({
    app_name = optional(string, "temporal-ui")
    channel  = optional(string, "1.23/edge")
    revision = optional(number, 0)
    units    = optional(number, 1)
    config   = optional(map(string), {})
  })
  default = {}
}

variable "temporal_admin" {
  description = "Inputs for temporal-admin-k8s charm module."
  type = object({
    app_name = optional(string, "temporal-admin")
    channel  = optional(string, "1.23/edge")
    revision = optional(number, 0)
    units    = optional(number, 1)
    config   = optional(map(string), {})
  })
  default = {}
}

variable "cos_configuration" {
  description = "Boolean value that enables COS integration."
  type        = bool
  default     = false
}

variable "existing_otel_collector_name" {
  description = "Name of an existing opentelemetry-collector-k8s deployed in the model to be reused. If cos_configuration is not true, this input is not used."
  type        = string
  default     = null
}
