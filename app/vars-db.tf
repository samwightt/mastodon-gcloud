###
### Variables for DB configuration
###



##
## Cloud SQL instance variables
##


variable "cloud_sql_db_name" {
  type = string
  description = "The name of the database to create in Cloud SQL."
  default = "mastodon-db"
}

variable "cloud_sql_availability_type" {
  type = string
  description = "The availability type of the Cloud SQL instance. Must be either `REGIONAL` or `ZONAL`."
  default = "ZONAL"
}

variable "cloud_sql_tier" {
  type = string
  description = "The tier of the Cloud SQL instance. Must be a valid tier for the database version."
  default = "db-f1-micro"
}

variable "cloud_sql_disk_size" {
  type = number
  description = "The size of the disk in GB."
  default = 10
}


##
## DB User variables
##


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

variable "db_password" {
  type = string
  description = "The password to use for the database."
  sensitive = true
}
