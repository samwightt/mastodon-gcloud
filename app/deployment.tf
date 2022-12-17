resource "kubernetes_deployment" "mastodon" {
  metadata {
    name = "${var.resource_prefix}-mastodon"
    labels = {
      app = "${var.resource_prefix}-mastodon"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "${var.resource_prefix}-mastodon"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.resource_prefix}-mastodon"
        }
      }

      spec {
        container {
          name = "web"
        }
      }
    }
  }
}