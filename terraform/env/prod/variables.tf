## ACCOUNT
variable "default_region" {
    description = "The default region to deploy to"
    type = string
}

## DNS
variable "registered_dns_name" {
  description = "The name of the DNS name registered to this project"
}

## VPC
variable "vpc_name"{
    description = "The name of the primary vpc"
    type = string
}

variable "vpc_cidr" {
    description = "The CIDR range for the vpc to use"
    type = string
}