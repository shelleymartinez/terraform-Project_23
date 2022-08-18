#---vpc/outputs.tf---

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_security_group" {
  value = aws_security_group.public_security_group.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet" {
  value = aws_subnet.private_subnet[*].id
}

output "web_sg" {
  value = aws_security_group.web_sg.id
}
