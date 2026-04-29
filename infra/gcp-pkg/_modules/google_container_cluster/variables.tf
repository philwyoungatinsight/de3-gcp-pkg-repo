variable "cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
}

variable "location" {
  description = <<-EOT
    GCP location for the cluster. A region creates a regional cluster (recommended —
    control plane is HA across zones). A zone creates a single-zone cluster.
    Example: "us-central1" or "us-central1-a".
  EOT
  type = string
}

variable "network" {
  description = "VPC network name or self-link the cluster will run in."
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "VPC subnetwork name or self-link the cluster nodes will use."
  type        = string
  default     = "default"
}

variable "deletion_protection" {
  description = "When true, Terraform will refuse to destroy the cluster. Set to false for dev clusters."
  type        = bool
  default     = false
}

# ── IP allocation (VPC-native) ─────────────────────────────────────────────────

variable "cluster_ipv4_cidr_block" {
  description = "CIDR range for Pod IP addresses. Empty string lets GKE choose automatically."
  type        = string
  default     = ""
}

variable "services_ipv4_cidr_block" {
  description = "CIDR range for Service (ClusterIP) addresses. Empty string lets GKE choose automatically."
  type        = string
  default     = ""
}

# ── Workload Identity ──────────────────────────────────────────────────────────

variable "workload_pool" {
  description = <<-EOT
    Workload Identity Pool to bind to the cluster (e.g. "<project>.svc.id.goog").
    Empty string disables Workload Identity.
  EOT
  type    = string
  default = ""
}

# ── Node pool ─────────────────────────────────────────────────────────────────

variable "node_pool_name" {
  description = "Name of the primary managed node pool."
  type        = string
  default     = "primary"
}

variable "node_count" {
  description = "Number of nodes per zone in the primary node pool."
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "GCE machine type for worker nodes."
  type        = string
  default     = "e2-medium"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB for each node."
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Boot disk type: pd-standard, pd-ssd, or pd-balanced."
  type        = string
  default     = "pd-standard"

  validation {
    condition     = contains(["pd-standard", "pd-ssd", "pd-balanced"], var.disk_type)
    error_message = "disk_type must be pd-standard, pd-ssd, or pd-balanced."
  }
}

variable "oauth_scopes" {
  description = "OAuth2 scopes for the node service account. The defaults grant logging, monitoring, and read-only GCS access."
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/trace.append",
  ]
}

variable "auto_repair" {
  description = "Enables automatic node repair."
  type        = bool
  default     = true
}

variable "auto_upgrade" {
  description = "Enables automatic node version upgrades."
  type        = bool
  default     = true
}

# ── Labels ────────────────────────────────────────────────────────────────────

variable "labels" {
  description = "GCP resource labels to apply to the cluster."
  type        = map(string)
  default     = {}
}
