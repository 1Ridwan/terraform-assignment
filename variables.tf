variable "instance_ami" { type = string }
variable "instance_type" { type = string }
variable "public_ip" { type = bool }
variable "change_user_data" { type = bool }


# networking

variable "vpc_cidr" { type = string }
variable "vpc_region" { type = string }
variable "subnet_cidr" { type = string }
variable "az" { type = string }