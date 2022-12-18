# Note: these must be *exactly the same* as the variables in cluster! Otherwise creation will fail!

variable "gcp_project_id" {
  type = string
  description = "The ID of the project to create the resources in. Must be the same as the variable defined in cluster."
}

variable "gcp_region" {
  type = string
  description = "The region to create the resources in. Must be the same as the variable defined in cluster."
  default = "us-central1"
}

variable "resource_prefix" {
  type = string
  description = "The prefix to use for the resources created. Must be the same as the variable defined in cluster."
}

variable "gke_cluster_name" {
  type = string
  description = "The name of the GKE cluster. Prefixed with resource_prefix."
  default = "cluster"
}

variable "redis_password" {
  type = string
  description = "The password to use for Redis."
}