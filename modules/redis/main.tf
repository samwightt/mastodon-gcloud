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

resource "kubernetes_secret" "redis_password" {
  metadata {
    name = "redis-${var.name}-password"
  }

  data = {
    REDIS_PASSWORD = var.password
  }
}

resource "helm_release" "redis" {
  name = var.name
  repository = "https://charts.bitnami.com/bitnami"
  chart = "redis"
  version = var.chart_version

  values = []

  # Sets up a Redis password so we can connect to the cluster.
  set {
    name = "auth.password"
    value = var.password
  }

  set {
    name = "image.tag"
    value = var.image_tag
  }

  set {
    name = "master.service.type"
    value = var.service_type
  }

  set {
    name = "architecture"
    value = var.architecture
  }

  set {
    name = "master.resources.requests.cpu"
    value = var.resources.cpu
  }

  set {
    name = "master.resources.requests.memory"
    value = var.resources.memory
  }

  set {
    name = "master.resources.limits.cpu"
    value = var.resources.cpu
  }

  set {
    name = "master.resources.limits.memory"
    value = var.resources.memory
  }
}