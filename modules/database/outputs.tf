output "k8s_service_account" {
  value = {
    name = kubernetes_service_account.db.metadata[0].name
  }
}

output "iam_service_account" {
  value = {
    id = google_service_account.db.id
    email = google_service_account.db.email
  }
}

output "user" {
  value = {
    username = google_sql_user.db_user.name
    password = google_sql_user.db_user.password
  }
  sensitive = true
}

output "instance" {
  value = {
    name = google_sql_database_instance.db.name
    region = google_sql_database_instance.db.region
  }
}