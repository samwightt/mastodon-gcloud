output "name" {
  value = var.name
}

output "secret" {
  value = {
    name = kubernetes_secret.rails_secrets.metadata[0].name
  }
}

output "configmap" {
  value = {
    name = kubernetes_config_map.rails_config_map.metadata[0].name
  }
}

