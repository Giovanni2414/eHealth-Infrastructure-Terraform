variable "region" {
  type        = string
  description = "region de despliegue"
}

variable "basic-name" {
  type        = string
  description = "Basic name for all resources"
}

variable "prefix" {
  description = "A prefix used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
}
