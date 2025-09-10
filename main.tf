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

module "ec2" {
    source = "./ec2"
    vpc_id = module.network.vpc_id
    public_subnet_id = module.network.public_subnet_id
    mysql_root_password = var.mysql_root_password
    db_user = var.db_user
    db_password = var.db_password
}