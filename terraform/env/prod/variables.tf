## ACCOUNT
variable "default_region" {
  description = "The default region to deploy to"
  type        = string
}

## DNS
variable "registered_domain" {
  description = "The name of the DNS name registered to this project"
}

variable "api_subdomain" {
  description = "The name of the DNS subdomain name registered to the api gw"
}

variable "assets_subdomain" {
  description = "The name of the DNS subdomain name registered to the cloudfront distro"
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

## APPLICATION
variable "application_prefix" {
  description = "Prefix for individual application. Helps connect specific resources to applications that use them"
  type        = string
}

## CLOUDFRONT
variable "assets_cloudfront_endpoint" {
  description = "The name of the subdomain name registered to site assets CF distro"
  type = string
}