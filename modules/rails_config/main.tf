terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.16.0"
    }
  }
}

resource "kubernetes_secret" "rails_secrets" {
  metadata {
    name = "${var.name}-secrets"

    labels = {
      "app.kubernetes.io/name" = "rails-secrets"
      "app.kubernetes.io/instance" = "${var.name}-secrets"
      "app.kubernetes.io/component" = "secret"
      "app.kubernetes.io/part-of" = "mastodon"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  data = {
    REDIS_PASSWORD = var.redis.password
    "REDIS_URL" = "redis://default:$(REDIS_PASSWORD)@${var.redis.service_name}-master:6379"

    DB_USER = var.db_user.username
    DB_PASS = var.db_user.password

    SECRET_KEY_BASE = var.rails_secrets.secret_key_base
    OTP_SECRET = var.rails_secrets.otp_secret
    VAPID_PUBLIC_KEY = var.rails_secrets.vapid_public_key
    VAPID_PRIVATE_KEY = var.rails_secrets.vapid_private_key
  }
}

resource "kubernetes_config_map" "rails_config_map" {
  metadata {
    name = "${var.name}-configmap"

    labels = {
      "app.kubernetes.io/name" = "rails-configmap"
      "app.kubernetes.io/instance" = "${var.name}-configmap"
      "app.kubernetes.io/component" = "configmap"
      "app.kubernetes.io/part-of" = var.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  data = {
    "DB_HOST" = "127.0.0.1"
    "DB_NAME" = var.db_name
    "RAILS_ENV" = "production"
    "CLOUDSQL_CONNECTION_NAME" = var.cloudsql_connection_name
  }
}