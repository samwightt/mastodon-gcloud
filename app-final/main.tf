terraform {
  cloud {
    organization = "urbanists-dot-social"
    workspaces {
      name = "app"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.44.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.16.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 2.7.1"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region = var.gcp_region
}

##
## Kubernetes providers
##

# Need to look up cluster config so that we can get the cluster's endpoint and CA cert.
data "google_container_cluster" "gke_cluster" {
  name = "${var.resource_prefix}-cluster"
  location = var.gcp_region
}

# Need the client config so we can get an auth token for the k8s provider.
data "google_client_config" "client" {}

locals {
  cluster_host = "https://${data.google_container_cluster.gke_cluster.endpoint}"
  cluster_token = data.google_client_config.client.access_token
  cluster_cert = base64decode(data.google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate)
}

provider "kubernetes" {
  host = local.cluster_host
  token = local.cluster_token
  cluster_ca_certificate = local.cluster_cert
}

provider "helm" {
  kubernetes {
    host = local.cluster_host
    token = local.cluster_token
    cluster_ca_certificate = local.cluster_cert
  }
}