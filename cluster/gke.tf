# Create a regional Autopilot cluster with sensible defaults, including
# application-layer secrets encryption.
#
# The first regional Autopilot cluster in an account is free to create.
# Non-autopilot clusters are only free if they are *zonal* clusters.
# Regional clusters offer the best availability and performance, so we create
# an autopilot cluster.
#
# We use workload identity in the other root module, but we don't have to
# enable it here because Autopilot clusters have workload identity enabled by default.
resource "google_container_cluster" "gke_cluster" {
  name = "${var.resource_prefix}-cluster"
  location = var.gcp_region
  enable_autopilot = true
  # There's a bug in the GCP provider. If we don't provide this empty ip_allocation_policy
  # block then cluster creation will fail.
  ip_allocation_policy {}

  # Enable application-level secrets encryption.
  database_encryption {
    state = "ENCRYPTED"
    key_name = google_kms_crypto_key.ase_crypto_key.id
  }

  depends_on = [google_project_service.gke_api]
}