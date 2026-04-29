resource "google_storage_bucket_object" "this" {
  name         = var.object_name
  bucket       = var.bucket_name
  content      = var.content
  content_type = var.content_type
}
