# Defines the database configuration. The database is hosted on Cloud SQL. Kubernetes resources may
# access the database using the Cloud SQL proxy. The proxy runs as a sidecar container in the
# same pod as the application container.

module "db" {
  source = "../modules/database"

  project_id = var.gcp_project_id
  region = var.gcp_region
  instance_name = "${var.resource_prefix}-db"

  db_user = {
    username = "mastodon"
    password = var.db_password
  }
}