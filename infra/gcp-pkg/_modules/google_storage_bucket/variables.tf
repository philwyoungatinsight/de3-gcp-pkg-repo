variable "bucket_name" {
  description = "Globally unique GCS bucket name."
  type        = string
}

variable "location" {
  description = <<-EOT
    GCS bucket location. Accepts regions (e.g. "US-CENTRAL1"), multi-regions
    ("US", "EU", "ASIA"), or dual-regions ("NAM4", "EUR4").
    Defaults to the unit's region in upper-case, which is a valid regional location.
  EOT
  type        = string
}

variable "storage_class" {
  description = "Default storage class: STANDARD, NEARLINE, COLDLINE, or ARCHIVE."
  type        = string
  default     = "STANDARD"
}

variable "force_destroy" {
  description = "Delete all objects when the bucket is destroyed (useful for ephemeral test buckets)."
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels (key/value tags) to apply to the bucket."
  type        = map(string)
  default     = {}
}

# ── Access / IAM ──────────────────────────────────────────────────────────────

variable "uniform_bucket_level_access" {
  description = <<-EOT
    Enables uniform bucket-level access, disabling per-object ACLs.
    GCP's recommended posture; required for hierarchical namespace buckets.
  EOT
  type    = bool
  default = true
}

variable "public_access_prevention" {
  description = <<-EOT
    Controls public access to the bucket.
      "enforced"  – blocks all public access regardless of IAM policies.
      "inherited" – follows the project/org policy (GCP default).
  EOT
  type    = string
  default = "inherited"

  validation {
    condition     = contains(["enforced", "inherited"], var.public_access_prevention)
    error_message = "public_access_prevention must be \"enforced\" or \"inherited\"."
  }
}

# ── Soft delete ───────────────────────────────────────────────────────────────

variable "soft_delete_retention_seconds" {
  description = <<-EOT
    Soft-delete retention window in seconds.  Deleted objects are recoverable
    for this duration.  GCP default is 604800 (7 days).
    Set to 0 to disable soft delete (saves storage cost on ephemeral buckets).
  EOT
  type    = number
  default = 0
}

# ── Versioning ────────────────────────────────────────────────────────────────

variable "versioning_enabled" {
  description = "Retains previous versions of objects on overwrite or delete."
  type        = bool
  default     = false
}

# ── Retention ─────────────────────────────────────────────────────────────────

variable "retention_period_seconds" {
  description = <<-EOT
    Minimum retention period in seconds for objects in the bucket.
    0 means no retention policy is applied (GCP default).
    Example: 86400 = 1 day, 2592000 = 30 days.
  EOT
  type    = number
  default = 0
}

variable "retention_is_locked" {
  description = <<-EOT
    If true, the retention policy cannot be reduced or removed.
    Only meaningful when retention_period_seconds > 0.
    WARNING: locking is irreversible.
  EOT
  type    = bool
  default = false
}

# ── Lifecycle ─────────────────────────────────────────────────────────────────

variable "lifecycle_rules" {
  description = <<-EOT
    List of lifecycle rules.  Each rule has one action and one or more conditions.

    action_type          – "Delete" or "SetStorageClass" (required).
    target_storage_class – destination class for SetStorageClass actions.

    Condition fields (all optional; at least one must be set):
      age                           – object age in days.
      created_before                – RFC 3339 date string, e.g. "2025-01-01".
      with_state                    – "LIVE", "ARCHIVED", or "ANY".
      matches_storage_class         – list of storage classes to match.
      num_newer_versions         – delete if this many newer versions exist.
      days_since_noncurrent_time – days since the object became noncurrent.
  EOT
  type = list(object({
    action_type           = string
    target_storage_class  = optional(string)
    age                   = optional(number)
    created_before        = optional(string)
    with_state            = optional(string)
    matches_storage_class = optional(list(string))
    num_newer_versions        = optional(number)
    days_since_noncurrent_time = optional(number)
  }))
  default = []
}
