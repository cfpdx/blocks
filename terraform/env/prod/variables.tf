## ACCOUNT
variable "default_region" {
  description = "The default region to deploy to"
  type        = string
}

variable "default_tags" {
  description = "The default set of tags to use for most resources"
}

## VPC
variable "vpc_name" {
  description = "The name of the primary vpc"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR range for the vpc to use"
  type        = string
}