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