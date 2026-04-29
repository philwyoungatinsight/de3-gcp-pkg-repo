output "bucket_name" {
  description = "Bucket that contains the object."
  value       = google_storage_bucket_object.this.bucket
}

output "object_name" {
  description = "Name of the object (key) in the bucket."
  value       = google_storage_bucket_object.this.name
}

output "generation" {
  description = "Generation number of the object."
  value       = google_storage_bucket_object.this.generation
}
