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
| `pgbouncer`                   | `pgbouncer-k8s`               | Connection pooler between Temporal services and PostgreSQL.     |
| `postgresql-k8s`              | `postgresql-k8s`              | Backend database for persistence and visibility data.           |
| _(Optional)_ `otel-collector` | `opentelemetry-collector-k8s` | Observability integration for COS.                              |

All Temporal services connect to PostgreSQL through **PgBouncer** (session pooling mode by default) for both **primary (db)** and **visibility** stores, and to **Temporal Admin** for schema management.

---

## API

### Inputs

The solution module exposes the following configurable inputs:

| Name                           | Type   | Description                                                                                         | Required |
| ------------------------------ | ------ | --------------------------------------------------------------------------------------------------- | -------- |
| `model_uuid`                   | string | Reference to an existing Juju model to deploy Temporal into                                         | true     |
| `postgresql`                   | object | Configuration for the `postgresql-k8s` charm module                                                 | false    |
| `pgbouncer`                    | object | Configuration for the `pgbouncer-k8s` charm                                                         | false    |
| `temporal_server`              | object | Configuration for the `temporal-k8s` charm module                                                   | false    |
| `temporal_ui`                  | object | Configuration for the `temporal-ui-k8s` charm module                                                | false    |
| `temporal_admin`               | object | Configuration for the `temporal-admin-k8s` charm module                                             | false    |
| `cos_configuration`            | bool   | Enables COS integration by deploying and relating `opentelemetry-collector-k8s`                     | false    |
| `existing_otel_collector_name` | string | Name of an existing `opentelemetry-collector-k8s` deployment to reuse (used only if COS is enabled) | false    |

Each of the charm input objects (`postgresql`, `pgbouncer`, `temporal_server`, `temporal_ui`, `temporal_admin`) supports the following fields:

| Field                | Type                   | Description                                                | Default                                                                                              |
| -------------------- | ---------------------- | ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `app_name`           | string                 | Application name to deploy                                 | Charm-specific                                                                                       |
| `channel`            | string                 | Charm channel to deploy from                               | `"1.23/edge"` for Temporal charms, `"14/stable"` for PostgreSQL, `"1/stable"` for PgBouncer          |
| `revision`           | number                 | Charm revision to pin. `null` unpins (latest for channel). | `0` for `postgresql`, `temporal_server`, `temporal_ui`, and `temporal_admin`; `null` for `pgbouncer` |
| `units`              | number                 | Number of application units                                | `1`                                                                                                  |
| `config`             | map(string)            | Charm-specific configuration options                       | `{}`                                                                                                 |
| `num-history-shards` | string (Temporal only) | Defines number of history shards for the Temporal server   | `"1"`                                                                                                |

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

| Integration                                               | Purpose                                            |
| --------------------------------------------------------- | -------------------------------------------------- |
| `pgbouncer ↔ postgresql`                                  | PgBouncer backend connection to PostgreSQL.        |
| `temporal-frontend ↔ pgbouncer`                           | Main database connection (via pool).               |
| `temporal-frontend ↔ pgbouncer (visibility)`              | Visibility database connection (via pool).         |
| `temporal-history ↔ pgbouncer`                            | History persistence (via pool).                    |
| `temporal-history ↔ pgbouncer (visibility)`               | History visibility store (via pool).               |
| `temporal-matching ↔ pgbouncer`                           | Matching persistence (via pool).                   |
| `temporal-matching ↔ pgbouncer (visibility)`              | Matching visibility store (via pool).              |
| `temporal-worker ↔ pgbouncer`                             | Worker persistence (via pool).                     |
| `temporal-worker ↔ pgbouncer (visibility)`                | Worker visibility store (via pool).                |
| `temporal-admin ↔ temporal-frontend`                      | Schema management for frontend.                    |
| `temporal-admin ↔ temporal-history`                       | Schema management for history.                     |
| `temporal-admin ↔ temporal-matching`                      | Schema management for matching.                    |
| `temporal-admin ↔ temporal-worker`                        | Schema management for worker.                      |
| `temporal-frontend ↔ temporal-ui`                         | UI access integration.                             |
| `temporal-frontend ↔ temporal-ui` (temporal-host-info)    | Frontend gRPC host and port for temporal-ui-k8s    |
| `temporal-frontend ↔ temporal-admin` (temporal-host-info) | Frontend gRPC host and port for temporal-admin-k8s |
| _(Optional)_ `otel-collector ↔ temporal-*`                | Metrics integration when COS is enabled.           |

---

## Usage

This solution module can be used standalone or as part of a higher-level Terraform orchestration layer.

### Example: Basic Deployment

Use the provided `just` recipe to create the model, apply, wait for all apps to become active, and clean up automatically:

```bash
just test
```

To apply manually from `modules/charmed-temporal`, first obtain the model UUID and append it to the variables file:

```bash
MODEL_UUID=$(juju show-model temporal-test --format=json | jq -r '."temporal-test"["model-uuid"]')
printf '\nmodel_uuid = "%s"\n' "${MODEL_UUID}" >> ./test/terraform_test.tfvars
terraform apply -var-file=./test/terraform_test.tfvars
```

The committed template [`test/terraform_test.tfvars`](test/terraform_test.tfvars) sets PostgreSQL `profile = "testing"` for lighter resource usage in CI/local runs. It does **not** commit secrets; `model_uuid` is injected at runtime.

For a manual apply, set the UUID of an existing Juju model in tfvars or on the CLI:

```hcl
model_uuid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

If you recreate the Juju model (new UUID) but keep an old `terraform.tfstate`, Terraform may report **unknown model** on refresh. Remove local state in this directory (`terraform.tfstate` and `terraform.tfstate.backup`) and apply again. **`just test`** does this automatically after `add-model`; manual or scripted applies still need a clean state when the model UUID changes.

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

To run Terraform destroy, remove the `temporal-test` model, and strip the appended `model_uuid` line from the tfvars file:

```bash
just destroy "./test/terraform_test.tfvars"
```

Paths are relative to `modules/charmed-temporal`.

### Local / CI test flow

`just test` runs `add-model`, removes local `terraform.tfstate` (so the new model UUID never clashes with a previous run), `validate_test_tfvars`, `apply`, then **`just wait-for-active`** (polls until every application in `temporal-test` is `active`, up to 20 minutes). It registers `just destroy` on exit so the model and tfvars line are cleaned up.

---

## Notes

- **PgBouncer:** Temporal services connect to PostgreSQL through `pgbouncer-k8s` (session pooling mode by default). Session pooling is required for Temporal because it uses protocol-level prepared statements, which are incompatible with transaction pooling mode.
- Each `juju_integration` uses `depends_on` on the **two charm modules/resources** it relates ([#18](https://github.com/canonical/charmed-temporal-solutions/issues/18)). Integrations are **not** chained to each other. Optional COS metrics integrations depend on the relevant Temporal **module** and the OpenTelemetry collector application when this module deploys it (`cos_configuration=true` without `existing_otel_collector_name`).
- Test/CI PostgreSQL settings are in [`test/terraform_test.tfvars`](test/terraform_test.tfvars); `just validate_test_tfvars` appends `model_uuid` for `temporal-test`.
- The Temporal Server charm requires the `num-history-shards` configuration to be set to a positive power of two (e.g., `1`, `2`, `4`).  
  This module provides a default of `"1"` to ensure smooth deployment.
- The Temporal Worker is pre-provisioned for activity execution.
- Charm `revision` optional defaults: `0` for `postgresql`, `temporal_server`, `temporal_ui`, and `temporal_admin`; `null` for `pgbouncer`. For `pgbouncer`, `null` means unpinned (latest for the channel).
- `existing_otel_collector_name` is only used when `cos_configuration=true`. If set without COS enabled, it will be ignored.
- Ensure outbound connectivity from your cluster to `api.charmhub.io` for charm downloads.

---

## Repository References

- [Temporal Kubernetes Operator](https://github.com/canonical/temporal-k8s-operator)
- [Temporal Admin Operator](https://github.com/canonical/temporal-admin-k8s-operator)
- [Temporal UI Operator](https://github.com/canonical/temporal-ui-k8s-operator)
- [PostgreSQL K8s Operator](https://github.com/canonical/postgresql-k8s-operator)
- [PgBouncer K8s Operator](https://github.com/canonical/pgbouncer-k8s-operator)
- [OpenTelemetry Collector K8s Operator](https://github.com/canonical/opentelemetry-collector-k8s-operator)
