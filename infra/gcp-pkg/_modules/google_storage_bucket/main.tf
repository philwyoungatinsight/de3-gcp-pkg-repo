resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  location      = var.location
  storage_class = var.storage_class
  force_destroy = var.force_destroy
  labels        = var.labels

  uniform_bucket_level_access = var.uniform_bucket_level_access
  public_access_prevention    = var.public_access_prevention

  soft_delete_policy {
    retention_duration_seconds = var.soft_delete_retention_seconds
  }

  dynamic "versioning" {
    for_each = var.versioning_enabled ? [1] : []
    content {
      enabled = true
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_period_seconds > 0 ? [1] : []
    content {
      retention_period = var.retention_period_seconds
      is_locked        = var.retention_is_locked
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action_type
        storage_class = lifecycle_rule.value.target_storage_class
      }
      condition {
        age                           = lifecycle_rule.value.age
        created_before                = lifecycle_rule.value.created_before
        with_state                    = lifecycle_rule.value.with_state
        matches_storage_class         = lifecycle_rule.value.matches_storage_class
        num_newer_versions         = lifecycle_rule.value.num_newer_versions
        days_since_noncurrent_time = lifecycle_rule.value.days_since_noncurrent_time
      }
    }
  }
}
