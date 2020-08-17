variable "aws_key_name" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}

#AWS Region
variable "aws_region" {
  default = "ca-central-1"
  #default = "us-east-1"
}

variable ami {
  type    = map
  default = {
    "ca-central-1" = "ami-019065a72fed818a1"
    "us-east-1"    = "ami-03c213bffcfd88a45"
  }
}
variable instance_type {
  default = "t2.micro"
}

#Server Names
variable server_name_1 {
  default = "WS-Server-1"
}
variable server_name_2 {
  default = "WS-Server-2"
}

#IGW
variable igw {
  default = "IGW-Final"
}

variable "instance_count" {
  default = "2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnets_public" {
  type = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "subnets_private" {
  type = list(string)
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}
