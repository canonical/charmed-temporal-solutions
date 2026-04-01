# Charmed Temporal Terraform Solution

This is a Terraform module that facilitates the deployment of **Charmed Temporal**, using the [Terraform Juju provider](https://github.com/juju/terraform-provider-juju/).  
For detailed usage and provider configuration, refer to the [Terraform provider documentation](https://registry.terraform.io/providers/juju/juju/latest/docs).

---

## Architecture Overview

This module deploys the following components and their relations:

| Component                     | Charm                         | Role                                                            |
| ----------------------------- | ----------------------------- | --------------------------------------------------------------- |
| `temporal-frontend`           | `temporal-k8s`                | Handles client requests and routes workflow tasks.              |
| `temporal-history`            | `temporal-k8s`                | Manages workflow event histories.                               |
| `temporal-matching`           | `temporal-k8s`                | Manages task queues and matching logic.                         |
| `temporal-worker`             | `temporal-k8s`                | Executes workflows and activities.                              |
| `temporal-admin`              | `temporal-admin-k8s`          | Manages Temporal namespaces, schemas, and system configuration. |
| `temporal-ui`                 | `temporal-ui-k8s`             | Provides the web interface for viewing workflows.               |
| `postgresql-k8s`              | `postgresql-k8s`              | Backend database for persistence and visibility data.           |
| _(Optional)_ `otel-collector` | `opentelemetry-collector-k8s` | Observability integration for COS.                              |

All Temporal services connect to PostgreSQL for both **primary (db)** and **visibility** stores and to **Temporal Admin** for schema management.

---

## API

### Inputs

The solution module exposes the following configurable inputs:

| Name                           | Type   | Description                                                                                         | Required |
| ------------------------------ | ------ | --------------------------------------------------------------------------------------------------- | -------- |
| `model_uuid`                   | string | Reference to an existing Juju model to deploy Temporal into                                         | true     |
| `postgresql`                   | object | Configuration for the `postgresql-k8s` charm module                                                 | false    |
| `temporal_server`              | object | Configuration for the `temporal-k8s` charm module                                                   | false    |
| `temporal_ui`                  | object | Configuration for the `temporal-ui-k8s` charm module                                                | false    |
| `temporal_admin`               | object | Configuration for the `temporal-admin-k8s` charm module                                             | false    |
| `cos_configuration`            | bool   | Enables COS integration by deploying and relating `opentelemetry-collector-k8s`                     | false    |
| `existing_otel_collector_name` | string | Name of an existing `opentelemetry-collector-k8s` deployment to reuse (used only if COS is enabled) | false    |

Each of the charm input objects (`postgresql`, `temporal_server`, `temporal_ui`, `temporal_admin`) supports the following fields:

| Field                | Type                   | Description                                              | Default                                                         |
| -------------------- | ---------------------- | -------------------------------------------------------- | --------------------------------------------------------------- |
| `app_name`           | string                 | Application name to deploy                               | Charm-specific                                                  |
| `channel`            | string                 | Charm channel to deploy from                             | `"1.23/edge"` for Temporal charms, `"14/stable"` for PostgreSQL |
| `revision`           | number                 | Charm revision to use. `0` means the latest available.   | `0`                                                             |
| `units`              | number                 | Number of application units                              | `1`                                                             |
| `config`             | map(string)            | Charm-specific configuration options                     | `{}`                                                            |
| `num-history-shards` | string (Temporal only) | Defines number of history shards for the Temporal server | `"1"`                                                           |

---

### Outputs

Upon apply, this module exports the following outputs:

| Name                             | Description                                                                       |
| -------------------------------- | --------------------------------------------------------------------------------- |
| `applications`                   | Map containing all charm modules that make up the Charmed Temporal deployment     |
| `frontend_certificates_requirer` | Map with `app_name` and `requires` endpoint for TLS certificates                  |
| `server_nginx_route_requirer`    | Map with `app_name` and `requires` endpoint for Temporal Server's NGINX route     |
| `ui_nginx_route_requirer`        | Map with `app_name` and `requires` endpoint for Temporal UI's NGINX route         |
| `openfga_requirer`               | Map with `app_name` and `requires` endpoint for OpenFGA                           |
| `s3_integrator_requirer`         | Map with `app_name` and `requires` endpoint for the S3 integrator charm           |
| `otel_collector_k8s`             | Map containing the deployed or reused OpenTelemetry Collector when COS is enabled |

---

## Relations

The following relations are automatically established:

| Integration                                   | Purpose                                  |
| --------------------------------------------- | ---------------------------------------- |
| `temporal-frontend ↔ postgresql`              | Main database connection.                |
| `temporal-frontend ↔ postgresql (visibility)` | Visibility database connection.          |
| `temporal-history ↔ postgresql`               | History persistence.                     |
| `temporal-history ↔ postgresql (visibility)`  | History visibility store.                |
| `temporal-matching ↔ postgresql`              | Matching persistence.                    |
| `temporal-matching ↔ postgresql (visibility)` | Matching visibility store.               |
| `temporal-worker ↔ postgresql`                | Worker persistence.                      |
| `temporal-worker ↔ postgresql (visibility)`   | Worker visibility store.                 |
| `temporal-admin ↔ temporal-frontend`          | Schema management for frontend.          |
| `temporal-admin ↔ temporal-history`           | Schema management for history.           |
| `temporal-admin ↔ temporal-matching`          | Schema management for matching.          |
| `temporal-admin ↔ temporal-worker`            | Schema management for worker.            |
| `temporal-frontend ↔ temporal-ui`             | UI access integration.                   |
| _(Optional)_ `otel-collector ↔ temporal-*`    | Metrics integration when COS is enabled. |

---

## Usage

This solution module can be used standalone or as part of a higher-level Terraform orchestration layer.

### Example: Basic Deployment

```bash
terraform apply -var-file=terraform_test.tfvars
```

Committed template: [`test/terraform_test.tfvars`](test/terraform_test.tfvars) sets `postgresql.config.profile = "testing"` for CI/local tests. Running `just validate_test_tfvars terraform_test.tfvars` copies that file to the target path and appends `model_uuid` from the `temporal-test` Juju model.

For a manual apply, use the UUID of an existing Juju model:

```hcl
model_uuid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

You can start from `test/terraform_test.tfvars` and add `model_uuid`, or pass vars on the CLI.

---

### COS Configuration

#### Enable COS Integration

To enable COS integration (deploy `opentelemetry-collector-k8s` and relate it to Temporal):

```bash
terraform apply -var cos_configuration=true
```

#### Use an Existing OpenTelemetry Collector

If an existing OpenTelemetry Collector is already deployed in the same model, reuse it instead of deploying a new one:

```bash
terraform apply -var cos_configuration=true -var existing_otel_collector_name="otel-collector"
```

---

### Cleanup

To remove the deployment and destroy the associated Juju model:

```bash
just destroy terraform_test.tfvars
```

---

## Notes

- Each `juju_integration` uses `depends_on` on the **two charm modules** it relates ([#18](https://github.com/canonical/charmed-temporal-solutions/issues/18)). Optional COS metrics integrations depend on the relevant Temporal **module** and the OTEL `juju_application` (when deployed by this module).
- Test/CI PostgreSQL headroom comes from [`test/terraform_test.tfvars`](test/terraform_test.tfvars) (`profile = "testing"`), merged with `model_uuid` by `just validate_test_tfvars`.
- The Temporal Server charm requires the `num-history-shards` configuration to be set to a positive power of two (e.g., `1`, `2`, `4`).  
  This module provides a default of `"1"` to ensure smooth deployment.
- The Temporal Worker is pre-provisioned for activity execution.
- Revisions default to `0`, meaning the latest charm revision for the given channel will be used automatically.
- `existing_otel_collector_name` is only used when `cos_configuration=true`. If set without COS enabled, it will be ignored.
- Ensure outbound connectivity from your cluster to `api.charmhub.io` for charm downloads.

---

## Repository References

- [Temporal Kubernetes Operator](https://github.com/canonical/temporal-k8s-operator)
- [Temporal Admin Operator](https://github.com/canonical/temporal-admin-k8s-operator)
- [Temporal UI Operator](https://github.com/canonical/temporal-ui-k8s-operator)
- [PostgreSQL K8s Operator](https://github.com/canonical/postgresql-k8s-operator)
- [OpenTelemetry Collector K8s Operator](https://github.com/canonical/opentelemetry-collector-k8s-operator)
