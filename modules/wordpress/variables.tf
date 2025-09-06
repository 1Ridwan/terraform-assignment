variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "instance_ami" {
  type = string
   default = "ami-046c2381f11878233"
}

variable "public_ip" {
    type = bool
    default = true
}

variable "change_user_data" {
    type = bool
    default = true
}