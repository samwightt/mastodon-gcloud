# Sets up Redis with the Bitnami Helm chart. Uses a single instance for now
# (multiple instances can be added later).
resource "random_password" "redis_password" {
  length = 128
  special = true
}

resource "kubernetes_secret" "redis_password" {
  metadata {
    name = "${var.resource_prefix}-redis-password"
  }

  data = {
    REDIS_PASSWORD = random_password.redis_password.result
  }
}

resource "helm_release" "redis" {
  name = "${var.resource_prefix}-redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart = "redis"
  version = "17.3.11"

  values = [
    file("${path.module}/redis-config.yml"),
  ]

  # Sets up a Redis password so we can connect to the cluster.
  set {
    name = "auth.password"
    value = random_password.redis_password.result
  }
}