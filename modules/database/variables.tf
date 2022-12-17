variable "project_id" {
  type = string
  description = "The project ID of the Google Cloud project to create the database in."
}

variable "region" {
  type = string
  description = "The GCP region to create the database in."
}

variable "instance_name" {
  type = string
  description = "The name of the database to create in Cloud SQL."

  validation {
    condition = length(var.instance_name) <= 20
    error_message = "The length of the instance name must be less than 20 charcters."
  }

  validation {
    condition = length(var.instance_name) >= 4
    error_message = "The instance name must be at least 4 characters long."
  }
}

variable "pg_version" {
  type = string
  description = "The Postgres version to deploy. Default is POSTGRES_14."
  default = "POSTGRES_14"
}

variable "db_name" {
  type = string
  description = "The name of the initial database to create. Default is 'app'."
  default = "app"
}

variable "db_user" {
  type = object({
    username = string
    password = string
  })
  description = "The admin user to create in the database."
  sensitive = true
}

variable "availability_type" {
  type = string
  description = "The availability type of the Cloud SQL instance. Must be either `REGIONAL` or `ZONAL`."
  default = "ZONAL"

  validation {
    condition = var.availability_type == "ZONAL" || var.availability_type == "REGIONAL"
    error_message = "The availability type must be ZONAL or REGIONAL."
  }
}

variable "tier" {
  type = string
  description = "The Cloud SQL DB tier to use for the database. Defaults to "
  default = "db-f1-micro"
}

variable "disk_size" {
  type = number
  description = "The size of the disk in GB. Default is 10GB."
  default = 10
}

variable "autoresize_limit" {
  type = number
  description = "The size of the disk that autoresize will resize to max (in GB). Default is 15GB."
  default = 15
}