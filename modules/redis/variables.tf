variable "password" {
  type = string
  description = "The password that should be used to authenticate with the Redis database."
  sensitive = true
}

variable "name" {
  type = string
  description = "The name of the Redis cluster."
}

variable "chart_version" {
  type = string
  description = "The version of the Bitnami helm chart to use."
  default = "17.3.11"
}

variable "image_tag" {
  type = string
  description = "The tag of the docker image to use (Redis version)"
  default = "7.0.5-debian-11-r15"
}

variable "service_type" {
  type = string
  description = "The type of service that Redis should use."
  default = "ClusterIP"
}

variable "resources" {
  type = object({
    cpu = string
    memory = string
  })
  description = "Kubernetes resource description. The same for both requests and limits because this is deployed on GKE Autopilot."
}

variable "architecture" {
  type = string
  description = "The kind of architecture to use. Default is `standalone`."
  default = "standalone"
}