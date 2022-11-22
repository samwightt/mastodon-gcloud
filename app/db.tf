# Defines the database configuration. The database is hosted on Cloud SQL. Kubernetes resources may
# access the database using the Cloud SQL proxy. The proxy runs as a sidecar container in the
# same pod as the application container.

# Cloud SQL instance definition
resource "google_sql_database_instance" "db" {
  database_version = "POSTGRES_14"
  region = var.gcp_region

  settings {
    # Smallest instance for testing + cheapness.
    tier = "db-f1-micro"
    # Disk size in GB.
    disk_size = 10
    # There's two availability types in Cloud SQL: ZONAL and REGIONAL.
    # ZONAL means the database is only run in one zone. REGIONAL means the database
    # has a failover replica running in another zone. REGIONAL is more expensive
    # but has higher availability.
    availability_type = "ZONAL"
    # Allow the disk to resize when it gets full.
    disk_autoresize = true
    disk_autoresize_limit = 15
  }

  # Wait on APIs to be ready before trying to create the instance.
  depends_on = [
    google_project_service.sql_api,
    google_project_service.sqladmin_api
  ]
}

# Database user account configuration:
#
# There are two types of users in Cloud SQL: IAM users and built-in users. By default, IAM
# users have no permissions when created. This makes it hard (or impossible) to set their permissions
# via Terraform. Built-in users are native Postgres users and have full permissions when created.
# Note: they do not have postgres `superadmin` privileges because Cloud SQL is a managed service.
# They have GCP's equivalent of `superadmin` privileges.
#
# Because of this, we create a built-in user for the application to use. We then store this in a kubernetes secret
# so that it can be accessed by the application. Kubernetes secrets are encrypted at rest and while in memory, see the
# `cluster` root module for more details.

# Create a random password for the database user.
resource "random_password" "db_password" {
  length = 100
  special = true
}

resource "google_sql_user" "db_user" {
  name = var.db_username
  type = "BUILT_IN"
  instance = google_sql_database_instance.db.name
  # Postgres BUILT_IN users require a password, GCP throws an error if you don't include one.
  password = random_password.db_password.result
}

resource "kubernetes_secret" "db_credentials" {
  metadata {
    name = "${var.resource_prefix}-db-credentials"
  }

  data = {
    DB_USER = google_sql_user.db_user.name
    DB_PASS = google_sql_user.db_user.password
    DB_NAME = var.db_name
  }
}

# Database authorization:
#
# By default, Cloud SQL blocks access to incoming connections. In order to connect, we need to give it
# a Google Cloud service account. We can do this using workload identity, which allows us to
# use a Kubernetes service account to authenticate to a Google Cloud service account. The k8s service account
# will be connected to our resources, and Google Cloud will magically use the GCloud service account
# to authenticate and allow access to resources.

# Create the service account:
resource "google_service_account" "db" {
  account_id = "${var.resource_prefix}-db-access"
  display_name = "Database service account"
}

# Make the kubernetes service account:
resource "kubernetes_service_account" "db" {
  metadata {
    name = "${var.resource_prefix}-db-access"

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
  k8s_service_account = "serviceAccount:${var.gcp_project_id}.svc.id.goog[default/${kubernetes_service_account.db.metadata[0].name}]"
}

resource "google_service_account_iam_binding" "db_access_binding" {
  service_account_id = google_service_account.db.id
  members = [local.k8s_service_account]
  role = "roles/iam.workloadIdentityUser"
}

# Give GCloud service account access ot the Cloud SQL client role. This allows the service account to connect
# to the Cloud SQL instance via Cloud SQL proxy. This is a project-level role. The role is called `roles/cloudsql.client`.
resource "google_project_iam_member" "cloud_sql_proxy_access" {
  member = "serviceAccount:${google_service_account.db.email}"
  role = "roles/cloudsql.client"
  project = var.gcp_project_id
}