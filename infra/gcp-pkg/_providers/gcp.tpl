terraform {
  required_version = ">= 1.3.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
  }
}
provider "google" {
  project = "${PROJECT}"
  region  = "${REGION}"
  %{if GCP_CREDENTIALS != ""}credentials = "${GCP_CREDENTIALS}"%{endif}
}
