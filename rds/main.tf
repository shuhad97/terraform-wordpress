
resource "aws_security_group" "rds_sg" {
  name = "wp-rds-sg" 
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ec2_to_rds" {
   type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id = aws_security_group.rds_sg.id
  source_security_group_id = var.ec2_sg_id
}

resource "aws_db_instance" "database" {
  allocated_storage    = 20
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t4g.micro"
  username             = var.db_user
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  multi_az =  false
  vpc_security_group_ids = [ aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.private_subnets.name
}

resource "aws_db_subnet_group" "private_subnets" {
  name       = "main"
  subnet_ids = [var.private_subnet_id_1,var.private_subnet_id_2]

  tags = {
    Name = "RDS subnet group"
  }
}