variable "instance_type" {
  type = string
}

variable "instance_ami" {
  type = string
}

variable "make_public" {
    type = bool
    default = true
}

variable "change_user_data" {
    type = bool
    default = true
}

variable "subnet_id" {
     type = string 
} 

variable "security_group_ids" {
     type = list(string) 
} 

variable "user_data" { 
     type = string 
}
