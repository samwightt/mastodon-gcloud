variable "db_service_account" {
  type = object({
    name = string
  })
  description = "The K8s service account that's used to allow access to the database."
}

variable "secret" {
  type = object({
    name = string
  })
  description = "The secret that should be used for this resource."
}

variable "config_map" {
  type = object({
    name = string
  })
  description = "The config map of environment variables for this resource."
}