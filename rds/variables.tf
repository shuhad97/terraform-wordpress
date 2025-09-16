variable "db_user" {
    description = "Database user"
    type = string
}

variable "db_password" {
    description = "Database password"
    type = string
}

variable "private_subnet_id_1" {
    description = "Private subnet ID for database"
    type = string
}

variable "private_subnet_id_2" {
    description = "Private subnet ID for database"
    type = string
}

variable "vpc_id" {
    description = "vpc"
    type = string
}

variable "ec2_sg_id" {
    description = "EC2 Security group"
    type = string
}