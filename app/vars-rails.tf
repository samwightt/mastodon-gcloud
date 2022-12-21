##
## Variables for Rails
##

variable "rails_secrets" {
  type = object({
    secret_key_base = string
    otp_secret = string
    vapid_public_key = string
    vapid_private_key = string
  })
  description = "Secrets for Rails needed by Mastodon."
  sensitive = true
}