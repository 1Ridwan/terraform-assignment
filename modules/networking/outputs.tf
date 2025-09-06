# subnet id needed to feed into wordpress module in root main.tf
output "subnet_id" {
    value = aws_subnet.public.id
}

# security group id needed to feed into wordpress module in root main.tf
output "security_group_id" {
    value = aws_security_group.instance_sg.id
}