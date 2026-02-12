variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "environment" {
  description = "The environment for deployment (e.g., dev, staging, prod)"
  type        = string
}

variable "region" {
  description = "The Azure region where resources will be deployed"
  type        = string
  default     = "westeurope"
}

variable "replicas" {
  description = "The number of replicas for the AKS cluster"
  type        = number
  default     = 2
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {
    environment = "production"
    project     = "asdasd"
  }
}