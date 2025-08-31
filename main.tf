terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.11.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

module "network" {
    source = "./network"
}