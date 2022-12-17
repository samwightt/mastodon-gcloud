##
## Database instance configuration
##

resource "google_sql_database_instance" "db" {
  name = var.instance_name
  region = var.region
  database_version = var.pg_version

  settings {
    # Smallest instance for testing + cheapness.
    tier = var.tier

    # Disk size in GB.
    disk_size = var.disk_size

    # There's two availability types in Cloud SQL: ZONAL and REGIONAL.
    # ZONAL means the database is only run in one zone. REGIONAL means the database
    # has a failover replica running in another zone. REGIONAL is more expensive
    # but has higher availability.
    availability_type = var.availability_type

    # Allow the disk to resize when it gets full.
    disk_autoresize = true
    disk_autoresize_limit = var.autoresize_limit
  }

  # Wait on APIs to be ready before trying to create the instance.
  depends_on = [
    google_project_service.sql_api,
    google_project_service.sqladmin_api
  ]
}

##
## Database User Configuration
##

# There are two types of users in Cloud SQL: IAM users and built-in users. By default, IAM
# users have no permissions when created. This makes it hard (or impossible) to set their permissions
# via Terraform. Built-in users are native Postgres users and have full permissions when created.
# Note: they do not have postgres `superadmin` privileges because Cloud SQL is a managed service.
# They have GCP's equivalent of `superadmin` privileges.
#
# Because of this, we create a built-in user for the application to use. We then store this in a kubernetes secret
# so that it can be accessed by the application. Kubernetes secrets are encrypted at rest and while in memory, see the
# `cluster` root module for more details.

resource "google_sql_user" "db_user" {
  type = "BUILT_IN"

  # Postgres BUILT_IN users require a password, GCP throws an error if you don't include one.
  name = var.db_user.username
  password = var.db_user.password

  instance = google_sql_database_instance.db.name
}