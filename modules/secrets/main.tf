terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.16.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = ">= 2.7.1"
    }
  }
}

resource "kubernetes_secret" "rails_secrets" {
  metadata {
    name = var.name

    labels = {
      "app.kubernetes.io/name" = "rails-secrets"
      "app.kubernetes.io/component" = "secret"
      "app.kubernetes.io/part-of" = "mastodon"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  data = {
    REDIS_PASSWORD = var.redis_password
    DB_USER = var.db_user.username
    DB_PASSWORD = var.db_user.password

    SECRET_KEY_BASE = var.rails_secrets.secret_key_base
    OTP_SECRET = var.rails_secrets.otp_secret
    VAPID_PUBLIC_KEY = var.rails_secrets.vapid_public_key
    VAPID_PRIVATE_KEY = var.rails_secrets.vapid_private_key
  }
}
