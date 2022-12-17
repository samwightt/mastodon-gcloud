##
## Kubernetes secret for db credentials
##

resource "kubernetes_secret" "db_credentials" {
  metadata {
    name = "${var.instance_name}-db-credentials"
  }

  data = {
    DB_USER = google_sql_user.db_user.name
    DB_PASS = google_sql_user.db_user.password
    DB_NAME = var.db_name
  }
}