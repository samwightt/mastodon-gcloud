terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.44.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.16.0"
    }
  }
}
