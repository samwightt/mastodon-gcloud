terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.16.0"
    }
  }
}

resource "kubernetes_service_account" "sidecar_job_controller" {
  metadata {
    name = "sidecar-job-controller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role" "sidecar_cluster_role" {
  metadata {
    name = "sidecar-job-controller"
  }

  rule {
    api_groups = [""]
    resources = ["pods"]
    verbs = ["delete", "get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources = ["pods/exec"]
    verbs = ["create", "get"]
  }
}

resource "kubernetes_cluster_role_binding" "sidecar_binding_cluster" {
  metadata {
    name = "sidecar-job-controller"
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.sidecar_job_controller.metadata[0].name
    namespace = kubernetes_service_account.sidecar_job_controller.metadata[0].namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.sidecar_cluster_role.metadata[0].name
  }
}

resource "kubernetes_deployment" "sidecar_controller_deployment" {
  metadata {
    namespace = "kube-system"
    name = "sidecar-controller"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "name" = "sidecar-controller"
      }
    }

    template {
      metadata {
        labels = {
          name = "sidecar-controller"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.sidecar_job_controller.metadata[0].name
        container {
          image = "nrmitchi/k8s-controller-sidecars:latest"
          image_pull_policy = "Always"
          name = "sidecar-controller"
          resources {
            limits = {
              cpu = "200m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
  
}

resource "kubernetes_job" "setup_db_job" {
  metadata {
    name = "setup-db-job"
  }

  spec {
    template {
      metadata {
        annotations = {
          "nrmitchi.com/sidecars" = "cloud-sql-proxy"
        }
      }

      spec {
        service_account_name = var.db_service_account.name
        restart_policy = "Never"

        container {
          name = "setup-db"
          image = "tootsuite/mastodon:latest"
          command = ["bundle", "exec", "rails", "db:migrate"]

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
          command = [
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
      }
    }
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "60s"
  }
}