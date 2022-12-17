output "password" {
  value = var.password
}

output "secret" {
  value = {
    name = kubernetes_secret.redis_password.metadata[0].name
  }
}

output "name" {
  value = var.name
}