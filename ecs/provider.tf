provider "aws" {
  region  = "ap-northeast-1"
  version = "~> 2.64.0"
}

terraform {
  required_version = ">= 0.12.0"

  backend "s3" {
    bucket  = "36rafts-tfstate"
    key     = "nukegara/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}
