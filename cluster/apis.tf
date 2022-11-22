# Google Cloud has APIs that Terraform can interact with, but some of them are not enabled by default.
# This takes care of enabling the ones needed for this module so that a user doesn't have
# to do it manually.

# Need KMS API for managing keys for application-level secrets encryption.
resource "google_project_service" "kms_api" {
  service = "cloudkms.googleapis.com"
}

# Need GKE API for managing GKE clusters.
resource "google_project_service" "gke_api" {
  service = "container.googleapis.com"
}

