#create instance
resource "aws_instance" "website_instance" {
  ami                     = var.instance_ami
  instance_type           = var.instance_type
  subnet_id               = module.networking.aws_subnet.public.id
  vpc_security_group_ids = [module.networking.aws_security_group.instance_sg.id]
  associate_public_ip_address = var.public_ip
  user_data = file("${path.module}../../wordpress-site.sh")
  user_data_replace_on_change = var.change_user_data

  tags = {
      Name = "wordpress_instance"
      }
}
