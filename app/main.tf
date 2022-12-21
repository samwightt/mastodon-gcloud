module "rails_config" {
  source = "../modules/rails_config"
  db_user = module.db.user
  rails_secrets = var.rails_secrets
  cloudsql_connection_name = module.db.instance.connection_name

  redis = {
    password = module.redis.password
    service_name = module.redis.service.name
  }
}

module "db_setup_job" {
  source = "../modules/db_setup_job"
  config_map = module.rails_config.configmap
  secret = module.rails_config.secret
  db_service_account = module.db.k8s_service_account
}