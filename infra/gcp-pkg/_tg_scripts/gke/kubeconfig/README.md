# gke/kubeconfig

Fetches `kubectl` credentials for a GKE cluster and writes a dedicated kubeconfig
file to `$_DYNAMIC_DIR/kubeconfig/<name>.yaml`.

## Invocation

Called by Terragrunt via the `null_resource__run-script` module:

```
run --build   fetch credentials (gcloud container clusters get-credentials)
run --clean   remove the dedicated kubeconfig file
```

The unit lives at
`infra/gcp-pkg/_stack/gcp/.../gke-cluster-dev/kubeconfig/` — a direct child of the
cluster unit. Its `dependency.config_path = "../"` ensures the cluster exists
before credentials are fetched.

## Configuration

All values are discovered dynamically from
`pwy-home-lab-pkg.yaml` — no hardcoded paths or names:

| Value | Discovery |
|---|---|
| `cluster_name` | gcp `config_params` entry that has a `cluster_name` key |
| `region` | gcp `config_params` entry that has a `region` key |
| `project` | top-level `providers.gcp.project` |
| `KUBECONFIG` filename | gcp `config_params` entry with `_wave: cloud.gke` and a `KUBECONFIG` key |

Default kubeconfig filename: `<cluster_name>_kubeconfig.yaml`.

## Output

The kubeconfig is written to `$_DYNAMIC_DIR/kubeconfig/<KUBECONFIG_FILE>`.
It is **never** merged into `~/.kube/config` or the framework's shared
kubeconfig. Use `--kubeconfig=<path>` or `KUBECONFIG=<path>` to reference it.

## Dependencies

- `gke-gcloud-auth-plugin` — installed automatically if missing (via `apt-get`
  for apt-managed gcloud installations, or `gcloud components install` otherwise)
- Active `gcloud` authentication with access to the target GCP project
