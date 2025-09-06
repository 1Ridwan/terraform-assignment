# output web server public ip address to standard output so I can visit the site

output "public_ip" {
    value = aws_instance.website_instance.public_ip
}