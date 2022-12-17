##
## Variables for Rails
##

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