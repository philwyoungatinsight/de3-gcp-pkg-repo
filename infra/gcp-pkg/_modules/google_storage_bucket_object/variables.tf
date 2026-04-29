variable "bucket_name" {
  description = "Name of the GCS bucket where the object will be stored."
  type        = string
}

variable "object_name" {
  description = "Object name (key) within the bucket."
  type        = string
  default     = "all-config"
}

variable "content" {
  description = "Object content to upload."
  type        = string
}

variable "content_type" {
  description = "Content-Type metadata for the object."
  type        = string
  default     = "application/json"
}
