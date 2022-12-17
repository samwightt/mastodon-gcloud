variable "name" {
  type = string
  description = "The name of the secret."
  default = "mastodon-rails-secrets"
}

variable "redis_password" {
  type = string
  description = "The password for Redis."
  sensitive = true
}

variable "db_user" {
  type = object({
    username = string
    password = string
  })
  description = "The user that can access the database."
  sensitive = true
}

variable "rails_secrets" {
  type = object({
    secret_key_base = string
    otp_secret = string
    vapid_public_key = string
    vapid_private_key = string
  })
  description = "Secrets that Rails needs to run."
  sensitive = true
}