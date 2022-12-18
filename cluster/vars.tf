# Defines all of the variables and their defaults for the cluster module.
# You can change these by modifying your terraform.tfvars file (do NOT commit this file to source control).

variable "gcp_project_id" {
  type = string
  description = "The ID of the Google Cloud project to create the resources in."
}

variable "gcp_region" {
  type = string
  description = "The Google Cloud region to create the resources in."
  default = "us-central1"
}

variable "gke_cluster_name" {
  type = string
  description = "The name of the GKE cluster. Prefixed with resource_prefix."
  default = "cluster"
}

variable "encryption_key_name" {
  type = string
  description = "The name of the encryption key to use for secrets encryption. Prefixed with resource_prefix."
  default = "ase-crypto-key"
}

variable "encryption_key_ring_name" {
  type = string
  description = "The name of the encryption key ring to use for secrets encryption. Prefixed with resource_prefix."
  default = "ase-key-ring"
}