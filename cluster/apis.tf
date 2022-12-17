##
## Google Cloud APIs to enable.
##

# Google Cloud has APIs that Terraform can interact with, but some of them are not enabled by default.
# If a user tries to run `terraform apply` without enabling the APIs first, Terraform will throw an error.
# To prevent this, we let Terraform manage all of the APIs that we need to do resource creation.
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

