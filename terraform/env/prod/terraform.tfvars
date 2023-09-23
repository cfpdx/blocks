## ACCOUNT
default_region="us-east-1"
default_tags = {
    env = "prod"
    managed_by = "terraform"
}

## VPC
vpc_name = "blocks-vpc"
vpc_cidr = "10.0.0.0/16"
private_subnet_1 = "private_sub1"
private_subnet_2 = "private_sub2"
public_subnet_1 = "public_sub1"
public_subnet_2 = "public_sub2"
data_subnet_1 = "data_sub1"
cache_subnet_1 = "cache_sub2"
