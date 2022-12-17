output "password" {
  value = var.password
}

output "name" {
  value = var.name
}

output "service" {
  value = {
    name = "${var.name}-master"
    labels = {
      "app.kubernetes.io/name" = "redis"
      "app.kubernetes.io/instance" = var.name
      "app.kubernetes.io/component" = "master"
      "app.kubernetes.io/managed-by" = "Helm"
    }
  }
}