#create instance
resource "aws_instance" "website_instance" {
  ami                     = var.instance_ami
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = var.security_group_ids
  associate_public_ip_address = var.public_ip
  user_data                   = var.user_data
  user_data_replace_on_change = var.change_user_data

  tags = {
      Name = "wordpress_instance"
      }
}
