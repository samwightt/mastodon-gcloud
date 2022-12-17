# Need Cloud SQL API for managing Cloud SQL instances.
resource "google_project_service" "sql_api" {
  service = "sql-component.googleapis.com"
}

# Need Cloud SQL Admin API for authenticating to Cloud SQL instances.
resource "google_project_service" "sqladmin_api" {
  service = "sqladmin.googleapis.com"
}
