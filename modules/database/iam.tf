##
## IAM Database Authorization
##

# By default, Cloud SQL blocks access to incoming connections. In order to connect, we need to give it
# a Google Cloud service account. We can do this using workload identity, which allows us to
# use a Kubernetes service account to authenticate to a Google Cloud service account. The k8s service account
# will be connected to our resources, and Google Cloud will magically use the GCloud service account
# to authenticate and allow access to resources.

# Create the service account:
resource "google_service_account" "db" {
  account_id = "${var.instance_name}-access"
  display_name = "${var.instance_name} service account"
}

# Make the kubernetes service account:
resource "kubernetes_service_account" "db" {
  metadata {
    name = "${var.instance_name}-db-access"

    # We need to annotate the service account with the Google Cloud service account's email.
    # This will tell kubernetes that the service account should be connected to the Google Cloud service account.
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.db.email
    }
  }
}

# Tell GCloud that the k8s service account should be connected to the GCloud service account.
# This is accomplished using the `roles/iam.workloadIdentityUser` role. The `member` of this policy binding
# is a service account with the following format: `serviceAccount:<project-id>.svc.id.goog[<namespace>/<service-account-name>]`.
# The square brackets must be included.
locals {
  k8s_service_account = "serviceAccount:${var.project_id}.svc.id.goog[default/${kubernetes_service_account.db.metadata[0].name}]"
}

resource "google_service_account_iam_binding" "db_access_binding" {
  service_account_id = google_service_account.db.id
  role = "roles/iam.workloadIdentityUser"
  members = [local.k8s_service_account]
}

# Give GCloud service account access to the Cloud SQL client role. This allows the service account to connect
# to the Cloud SQL instance via Cloud SQL proxy. This is a project-level role. The role is called `roles/cloudsql.client`.
resource "google_project_iam_member" "cloud_sql_proxy_access" {
  role = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.db.email}"
  project = var.project_id
}