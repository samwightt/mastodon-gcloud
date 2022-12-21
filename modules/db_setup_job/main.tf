terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.16.0"
    }
  }
}
resource "kubernetes_job" "setup_db_job" {
  metadata {
    name = "setup-db-job"
  }

  spec {
    template {
      spec {
        service_account_name = var.db_service_account.name
        restart_policy = "Never"

        volume {
          name = "kubexit"
          empty_dir {}
        }

        volume {
          name = "graveyard"
          empty_dir {
            medium = "Memory"
          }
        }

        container {
          name = "setup-db"
          image = "tootsuite/mastodon:latest"
          command = ["/kubexit/kubexit", "bundle", "exec", "rails", "db:migrate"]

          env {
            name = "KUBEXIT_NAME"
            value = "setup-db"
          }
          env {
            name = "KUBEXIT_GRAVEYARD"
            value = "/graveyard"
          }
          env {
            name = "KUBEXIT_BIRTH_DEPS"
            value = "cloudsql-proxy"
          }
          env {
            name = "KUBEXIT_POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "KUBEXIT_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          volume_mount {
            mount_path = "/graveyard"
            name = "graveyard"
          }
          volume_mount {
            name = "kubexit"
            mount_path = "/kubexit"
          }

          resources {
            requests = {
              memory = "1Gi"
              cpu = "750m"
            }
          }

          env_from {
            config_map_ref {
              name = var.config_map.name
            }
          }

          env_from {
            secret_ref {
              name = var.secret.name
            }
          }
        }

        container {
          name = "cloud-sql-proxy"
          image = "gcr.io/cloudsql-docker/gce-proxy:1.33.1"

          volume_mount {
            name = "kubexit"
            mount_path = "/kubexit"
          }

          volume_mount {
            name = "graveyard"
            mount_path = "/graveyard"
          }

          env {
            name = "KUBEXIT_NAME"
            value = "cloudsql-proxy"
          }
          env {
            name = "KUBEXIT_GRAVEYARD"
            value = "/graveyard"
          }
          env {
            name = "KUBEXIT_DEATH_DEPS"
            value = "setup-db"
          }

          command = [
            "/kubexit/kubexit",
            "/cloud_sql_proxy",
            "-log_debug_stdout",
            "-instances=$(CLOUDSQL_CONNECTION_NAME)=tcp:5432"
          ]

          security_context {
            run_as_non_root = true
          }

          env_from {
            config_map_ref {
              name = var.config_map.name
            }
          }

          resources {
            requests = {
              memory = "250Mi"
              cpu = "250m"
            }
          }
        }

        init_container {
          name = "kubexit"
          image = "karlkfi/kubexit:latest"
          command = ["cp", "/bin/kubexit", "/kubexit/kubexit"]
          volume_mount {
            name = "kubexit"
            mount_path = "/kubexit"
          }
        }
      }
    }
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "60s"
  }
}