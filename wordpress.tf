#create instance
resource "aws_instance" "website_instance" {
  ami                     = var.instance_ami
  instance_type           = var.instance_type
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true;
  user_data = file("${path.module}/wordpress-site.sh")
  tags = {
      Name = "wordpress_instance"
      }
  user_data_replace_on_change = true
}
