# Charmed Temporal Terraform Solution

This is a Terraform module that facilitates the deployment of **Charmed Temporal**, using the [Terraform Juju provider](https://github.com/juju/terraform-provider-juju/).  
For detailed usage and provider configuration, refer to the [Terraform provider documentation](https://registry.terraform.io/providers/juju/juju/latest/docs).

---

## API

### Inputs

The solution module exposes the following configurable inputs:

| Name | Type | Description | Required |
|------|------|-------------|-----------|
| `model` | string | Reference to an existing Juju model to deploy Temporal into | true |
| `postgresql` | object | Configuration for the `postgresql-k8s` charm module | false |
| `temporal_server` | object | Configuration for the `temporal-k8s` charm module | false |
| `temporal_ui` | object | Configuration for the `temporal-ui-k8s` charm module | false |
| `temporal_admin` | object | Configuration for the `temporal-admin-k8s` charm module | false |
| `cos_configuration` | bool | Enables COS integration by deploying and relating `grafana-agent-k8s` | false |
| `existing_grafana_agent_name` | string | Name of an existing `grafana-agent-k8s` deployment to reuse (used only if COS is enabled) | false |

Each of the charm input objects (`postgresql`, `temporal_server`, `temporal_ui`, `temporal_admin`) supports the following fields:

| Field | Type | Description | Default |
|-------|------|-------------|----------|
| `app_name` | string | Application name to deploy | Charm-specific |
| `channel` | string | Charm channel to deploy from | `"1.23/edge"` for Temporal charms, `"14/stable"` for PostgreSQL |
| `revision` | number | Charm revision to use. `0` means the latest available. | `0` |
| `units` | number | Number of application units | `1` |
| `config` | map(string) | Charm-specific configuration options | `{}` |
| `num-history-shards` | string (Temporal only) | Defines number of history shards for the Temporal server | `"1"` |

---

### Outputs

Upon apply, this module exports the following outputs:

| Name | Description |
|------|-------------|
| `applications` | Map containing all charm modules that make up the Charmed Temporal deployment |
| `frontend_certificates_requirer` | Map with `app_name` and `requires` endpoint for TLS certificates |
| `server_nginx_route_requirer` | Map with `app_name` and `requires` endpoint for Temporal Server’s NGINX route |
| `ui_nginx_route_requirer` | Map with `app_name` and `requires` endpoint for Temporal UI’s NGINX route |
| `openfga_requirer` | Map with `app_name` and `requires` endpoint for OpenFGA |
| `s3_integrator_requirer` | Map with `app_name` and `requires` endpoint for the S3 integrator charm |
| `grafana_agent_k8s` | Map containing the deployed or reused Grafana Agent when COS is enabled |

---

## Usage

This solution module can be used standalone or as part of a higher-level Terraform orchestration layer.

### Example: Basic Deployment

```bash
terraform apply -var-file=test/terraform_test.tfvars
```

Sample `terraform_test.tfvars`:

```hcl
model = "temporal-test"
```

With this minimal input, all charms will be deployed with their default configuration and automatically related.

---

### COS Configuration

#### Enable COS Integration

To enable COS integration (deploy `grafana-agent-k8s` and relate it to Temporal):

```bash
terraform apply -var cos_configuration=true
```

#### Use an Existing Grafana Agent

If an existing Grafana Agent is already deployed in the same model, reuse it instead of deploying a new one:

```bash
terraform apply -var cos_configuration=true -var existing_grafana_agent_name="grafana-agent"
```
--

### Cleanup

To remove the deployment and destroy the associated Juju model:

```bash
just destroy ./test/terraform_test.tfvars
```

---

### Notes

- The Temporal Server charm requires the `num-history-shards` configuration to be set to a positive power of two (e.g., `1`, `2`, `4`).  
  This module provides a default of `"1"` to ensure smooth deployment.
- Revisions default to `0`, meaning the latest charm revision for the given channel will be used automatically.
- `existing_grafana_agent_name` is only used when `cos_configuration=true`. If set without COS enabled, it will be ignored.
