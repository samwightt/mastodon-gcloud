variable "name" {
  type = string
  description = "The name to put before all resources."
  default = "mastodon-rails"
}

variable "redis" {
  type = object({
    service_name = string
    password = string
  })
  description = "Details for Redis connection."
  sensitive = true
}

variable "cloudsql_connection_name" {
  type = string
  description = "The connection name of the CloudSQL instance."
}

variable "db_name" {
  type = string
  description = "The name of the database to use."
  default = "app"
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