# Google Cloud has APIs that Terraform can interact with, but some of them are not enabled by default.
# This takes care of enabling the ones needed for this module so that a user doesn't have
# to do it manually.

# Need GKE API for managing GKE clusters.
resource "google_project_service" "gke_api" {
  service = "container.googleapis.com"
}

# Need Cloud SQL API for managing Cloud SQL instances.
resource "google_project_service" "sql_api" {
  service = "sql-component.googleapis.com"
}

# Need Cloud SQL Admin API for authenticating to Cloud SQL instances.
resource "google_project_service" "sqladmin_api" {
  service = "sqladmin.googleapis.com"
}