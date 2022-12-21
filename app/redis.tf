module "redis" {
  source = "../modules/redis"

  name = "mastodon-redis"
  password = var.redis_password
  resources = {
    cpu = "500m"
    memory = "1Gi"
  }
}