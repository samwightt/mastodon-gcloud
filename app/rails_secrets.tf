# Sets up Kubernetes secrets for Rails secrets and credentials.
resource "kubernetes_secret" "mastodon_secrets" {
  metadata {
    name = "${var.resource_prefix}-mastodon-secrets"
  }

  data = {
    SECRET_KEY_BASE = var.secret_key_base
    OTP_SECRET = var.otp_secret
    VAPID_PUBLIC_KEY = var.vapid_public_key
    VAPID_PRIVATE_KEY = var.vapid_private_key
  }
}