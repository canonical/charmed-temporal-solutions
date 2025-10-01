
variable "model" {
  description = "Reference to an existing model resource or data source for the model to deploy to."
  type        = string
  default     = null
}

variable "temporal_server" {
  description = "Inputs for temporal-k8s charm module."
  type = object({
    app_name = string
    channel  = string
    revision = number
    units    = number
    config   = optional(map(string), {})
  })
}

variable "postgresql" {
  description = "Inputs for postgresql-k8s charm module."
  type = object({
    app_name = string
    channel  = string
    revision = number
    units    = number
    config   = optional(map(string), {})
  })
}

variable "temporal_ui" {
  description = "Inputs for temporal-ui-k8s charm module."
  type = object({
    app_name = string
    channel  = string
    revision = number
    units    = number
    config   = optional(map(string), {})
  })
}

variable "temporal_admin" {
  description = "Inputs for temporal-admin-k8s charm module."
  type = object({
    app_name = string
    channel  = string
    revision = number
    units    = number
    config   = optional(map(string), {})
  })
}

variable "cos_configuration" {
  description = "Boolean value that enables COS integration."
  type        = bool
  default     = false
}

variable "existing_grafana_agent_name" {
  description = "Name of an existing grafana-agent-k8s deployed in the model to be reused. If cos_configuration is not true, this input is not used."
  type        = string
  default     = null
}
