terraform {
  backend "s3" {
    bucket = "blocks-remote-tf-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform_state"
  }
}

provider "aws" {
  region = var.default_region
  default_tags {
    tags = {
      env        = "prod"
      managed_by = "terraform"
    }
  }
}
