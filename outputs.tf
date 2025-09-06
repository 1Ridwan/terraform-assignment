output "public_ip" {
    value = module.wordpress.aws_instance.website_instance.public_ip
}