variable "gcp_project_id" {
  type = string
  description = "The ID of the project to create the resources in."
}

variable "gcp_region" {
  type = string
  description = "The region to create the resources in."
  default = "us-central1"
}

variable "resource_prefix" {
  type = string
  description = "The prefix to use for the resources created."
}

variable "db_username" {
  type = string
  description = "The username to use for the database."
  default = "mastodon"
}

variable "db_name" {
  type = string
  description = "The database name to use for the database."
  default = "mastodon"
}

variable "secret_key_base" {
  type = string
  description = "SECRET_KEY_BASE for Mastodon. Generate with `rake secret`. Changing this will break all browser sessions."
  sensitive = true
}

variable "otp_secret" {
  type = string
  description = "OTP_SECRET for Mastodon. Generate with `rake secret`. Changing this will break 2FA sessions."
  sensitive = true
}

variable "vapid_public_key" {
  type = string
  description = "VAPID_PUBLIC_KEY for Mastodon. Generate with `rake mastodon:webpush:generate_vapid_key`. Changing this will break push notifications."
  sensitive = true
}

variable "vapid_private_key" {
  type = string
  description = "VAPID_PRIVATE_KEY for Mastodon. Generate with `rake mastodon:webpush:generate_vapid_key`. Changing this will break push notifications."
  sensitive = true
}