resource "aws_security_group" "wordpress-sg" {
  
  name = "wordpress-sg"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id = var.vpc_id

  ingress  {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
      }

  ingress  {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

resource "aws_instance" "ec2-instance" {
  ami           = data.aws_ami.ubuntu.id

  instance_type = "t2.micro"

  user_data = templatefile("${path.module}/user_data.sh.tpl",{
    rds_address = var.rds_address
    db_user = var.db_user,
    db_password = var.db_password  
  })

  subnet_id = var.public_subnet_id

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.wordpress-sg.id]

  tags = {
    Name = "public-instance"
  }

}