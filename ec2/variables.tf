variable "public_subnet_id" {
    description = "public subnet for ec2 instance"
    type = string
}

variable "vpc_id" {
    description = "vpc network id"
    type = string
}

variable "db_user" {
    description = "Database user"
    type = string
}

variable "db_password" {
    description = "Database password"
    type = string
}

variable "mysql_root_password" {
  description = "MySQL Root Password"
  type = string
}

variable "rds_address" {
  description = "Endpoint for RDS"
  type = string
}