# Runs a job that sets up the database.

locals {
  secret_environment_variables = {
    env = [
      {
        name = "SECRET_KEY_BASE"
      }
    ]
  }
}

resource "kubernetes_job" "setup_db" {
  metadata {
    name = "${var.resource_prefix}-setup-db"
  }

  spec {
    template {
      spec {
        service_account_name = kubernetes_service_account.db.metadata[0].name

        container {
          name = "setup-db"
          image = "tootsuite/mastodon:latest"
          command = ["bundle", "exec", "rails", "db:migrate"]

          resources {
            requests = {
              memory = "750Mi"
              cpu: "500m"
            }
          }

          env {
            name = "DB_HOST"
            value = "127.0.0.1"
          }
          env {
            name = "RAILS_ENV"
            value = "production"
          }
          env {
            name = "REDIS_URL"
            value = "redis://default:$(REDIS_PASSWORD)@${helm_release.redis.name}-master:6379"
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.db_credentials.metadata[0].name
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.mastodon_secrets.metadata[0].name
            }
          }
        }

        container {
          name = "cloud-sql-proxy"
          image = "gcr.io/cloudsql-docker/gce-proxy:1.33.1"
          command = [
            "/cloud_sql_proxy",
            "-log_debug_stdout",
            "-instances=${google_sql_database_instance.db.connection_name}=tcp:5432"
          ]

          security_context {
            run_as_non_root = true
          }

          resources {
            requests = {
              memory = "250Mi"
              cpu: "250m"
            }
          }
        }
      }

      metadata {}
    }
  }
}