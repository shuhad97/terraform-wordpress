variable "db_user" {
  description = "Database user"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket name"
  type= string
}

variable "region" {
  description = "AWS region"
  type = string
}
