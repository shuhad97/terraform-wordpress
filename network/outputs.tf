output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "public_subnet_id" {
    value = aws_subnet.public_subnet.id
}

output "private_subnet_id_1" {
    value = aws_subnet.private_subnet_1.id
}

output "private_subnet_id_2" {
    value = aws_subnet.private_subnet_2.id
}