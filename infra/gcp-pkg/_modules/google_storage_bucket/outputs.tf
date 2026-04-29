output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.this.name
}

output "bucket_url" {
  description = "Base URL of the bucket (gs://...)"
  value       = google_storage_bucket.this.url
}
