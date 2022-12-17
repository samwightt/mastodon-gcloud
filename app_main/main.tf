module "rails_secrets" {
  source = "../modules/secrets"
  db_user = module.db.user
  redis_password = module.redis.password
  rails_secrets = var.rails_secrets
}