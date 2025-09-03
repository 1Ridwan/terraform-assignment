output "public_ip" {
    value = aws_instance.website_instance.public_ip
}

output "instance_id" { 
    description = "The id of the EC2 instance"
    value = aws_instance.website_instance.id
    }
