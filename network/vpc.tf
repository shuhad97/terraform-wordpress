resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    tags = {
      Name = "${var.project_name}-vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidr
    
    tags = {
      Name = "${var.project_name}-public-subnet"
    }

}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_cidr
    
    tags = {
      Name = "${var.project_name}-private-subnet"
    }

}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.project_name}-igw"
    }

}


resource "aws_route_table" "public_route_table"{
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "public-route"
    }

}


resource "aws_route_table_association" "public_assoc" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

