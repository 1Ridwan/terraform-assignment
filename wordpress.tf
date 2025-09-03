#create instance in private instance in AZ1
resource "aws_instance" "website_instance" {
  ami                     = var.instance_ami
  instance_type           = var.instance_type
  subnet_id = aws_subnet.public.id
  availability_zone = var.az
  region = var.vpc_region
  user_data = file("${path.module}/wordpress-site.sh")
  tags = {
      Name = "wordpress_instance"
      }
  user_data_replace_on_change = true
}