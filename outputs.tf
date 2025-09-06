# output public ip of web server to stdout

output "public_ip" {
    value = module.wordpress.public_ip
}