variable "vpc_cidr" {
    type = string
  default = "10.0.0.0/16"
}

variable "vpc_region" {
    type = string  
    default = "eu-west-2"
}

variable "subnet_cidr" {
    type = string  
    default = "10.0.0.0/28"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "instance_ami" {
  type = string
   default = "ami-046c2381f11878233"
}

variable "az" {
  type = string
  default = "eu-west-2a"
}

variable "db_host"      { type = string }          # e.g., mydb.xxxxxx.eu-west-2.rds.amazonaws.com
variable "db_name"      { type = string }
variable "db_user"      { type = string }
variable "db_password"  { 
    type = string 
    sensitive = true 
}
