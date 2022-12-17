# This file is where we define all of the providers we'll use, as well as define their configs.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.44.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region = var.gcp_region
}
