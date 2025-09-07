# dynamically retrieve most recent ubuntu image

data "aws_ami" "ubuntu_latest" {
  owners = ["099720109477"] # canonical
  filter {
    name   = "image-id"
    values = [var.instance_ami]
}
}

# create instance wordpress server
resource "aws_instance" "website_instance" {
  ami                         = data.aws_ami.ubuntu_latest.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.make_public
  user_data                   = var.user_data
  user_data_replace_on_change = var.change_user_data

  tags = {
      Name = "wordpress_instance"
      }
}
