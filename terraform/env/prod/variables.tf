## ACCOUNT
variable "default_region" {
    description = "The default region to deploy to"
    type = string
}

variable "default_tags" {
    description = "The default set of tags to use for most resources"
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

variable "private_subnet_1"{
    description = "Name of private subnet used by vpc"
    type = string
}

variable "private_subnet_2"{
    description = "Name of private subnet used by vpc"
    type = string
}

variable "public_subnet_1"{
    description = "Name of public subnet used by vpc"
    type = string
}

variable "public_subnet_2"{
    description = "Name of public subnet used by vpc"
    type = string
}

variable "data_subnet_1"{
    description = "Name of the database subnet used by vpc"
    type = string
}

variable "cache_subnet_1"{
    description = "Name of the elasticache subnet used by vpc"
    type = string
}
