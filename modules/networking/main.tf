# vpc
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  region = var.vpc_region
  tags = {
    Name = "main"
  }
}

# subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true # give subnet public IP
  tags = {
    Name = "public_subnet"
  }
}

# internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# create route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public_route_table"
  }
}

# internet access for public subnet
resource "aws_route" "public_default_ipv4" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id 
}

# associate the route table for public subnet
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

# create security group for instance
resource "aws_security_group" "instance_sg" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "instance-sg"
  }
}

# allow all incoming HTTP traffic so website can be viewed
resource "aws_vpc_security_group_ingress_rule" "http_in" {
  security_group_id = aws_security_group.instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80         
}

# allow SSH only from my IP address ( var.my_ip hidden in .tfvars )
resource "aws_vpc_security_group_ingress_rule" "restrict_ssh" {
  security_group_id = aws_security_group.instance_sg.id
  cidr_ipv4         = var.my_ip
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22           
}

# allow all outgoing traffic to the internet so instance can download packages/updates etc.
resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}