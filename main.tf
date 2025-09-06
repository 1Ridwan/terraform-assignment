module "wordpress" {
  source = "./modules/wordpress"
  instance_ami                         = var.instance_ami
  instance_type               = var.instance_type
  public_ip = var.public_ip
  change_user_data = var.change_user_data
  subnet_id               = module.networking.subnet_id
  security_group_ids = [module.networking.security_group_id]

  user_data           = file("${path.root}/wordpress-site.sh")
}

module "networking" {
    source = "./modules/networking"
    vpc_cidr = var.vpc_cidr
    vpc_region = var.vpc_region
    subnet_cidr = var.subnet_cidr
    az = var.az
}
