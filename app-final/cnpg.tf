resource "helm_release" "cnpg_operator" {
  repository = "https://cloudnative-pg.github.io/charts"
  chart = "cloudnative-pg"
  namespace = "cnpg-system"
  create_namespace = true
  name = "cnpg"
}

resource "kubernetes_namespace" "mastodon_namespace" {
  metadata {
    annotations = {
      name = "mastodon-namespace"
    }

    name = "mastodon"
  }
}

resource "kubernetes_manifest" "database_cluster" {
  manifest = {
    "apiVersion" = "postgresql.cnpg.io/v1"
    "kind" = "Cluster"
    "metadata" = {
      "name" = "mastodon-db"
      "namespace" = kubernetes_namespace.mastodon_namespace.metadata[0].name
    }
    "spec" = {
      "instances" = 3
      "imageName" = "ghcr.io/cloudnative-pg/postgresql:15.1-6@sha256:72b6ce2d602b3b5afe044971be9f5adb9f9bc0ff294b18a8523e81fc127daa96"
      "primaryUpdateStrategy" = "unsupervised"
      "storage" = {
        "size" = "15Gi"
      }
    }
  }
}