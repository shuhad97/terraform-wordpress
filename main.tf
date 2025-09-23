terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.11.0"
    }
  }
  backend "s3" {
    bucket = "wordpress-bucket-shu"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = var.region
}

module "network" {
  source = "./network"
}

module "ec2" {
  source           = "./ec2"
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_id
  db_user          = var.db_user
  db_password      = var.db_password
  rds_address      = module.rds.rds-address
}

module "rds" {
  source              = "./rds"
  ec2_sg_id           = module.ec2.ec2_sg_id
  db_user             = var.db_user
  db_password         = var.db_password
  vpc_id              = module.network.vpc_id
  private_subnet_id_1 = module.network.private_subnet_id_1
  private_subnet_id_2 = module.network.private_subnet_id_2
}