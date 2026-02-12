variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "region" {
  description = "Azure region for resources"
  type        = string
}

variable "replicas" {
  description = "Number of replicas for the AKS cluster"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    environment = "production"
    application = "my-django-app"
  }
}