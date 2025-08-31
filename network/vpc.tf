resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/24"

    tags = {
      Name = "wordpress-vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.0.0/27"
    
    tags = {
      Name = "wordpress-public-subnet"
    }

}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.0.128/25"
    
    tags = {
      Name = "wordpress-private-subnet"
    }

}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "wordpress-igw"
    }

}

resource "aws_eip" "nat_ip" {
  domain   = "vpc"

    tags = {
        Name = "wordpress-nat-eip"
    }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "wordpress-ngw"
  }

  depends_on = [aws_internet_gateway.igw]
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


resource "aws_route_table" "private_route_table"{
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.ngw.id
    }

    tags = {
        Name = "private-route"
    }
}


resource "aws_route_table_association" "public_assoc" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_assoc" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route_table.id
}

