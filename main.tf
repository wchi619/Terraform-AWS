#Provider
provider "aws" {
  region        = var.aws_region
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
}

#Create VPC
resource "aws_vpc" "vpc-final" {
  cidr_block           = var.vpc_cidr
  tags = {
    Name = "VPC-Final"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "igw-final" {
  vpc_id = aws_vpc.vpc-final.id
  tags = {
      Name = "IGW-Final"
  }
}

#Create Subnet - Public
resource "aws_subnet" "public" {
  count             = length(var.subnets_public)
  vpc_id            = aws_vpc.vpc-final.id
  cidr_block        = element(var.subnets_public,count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Subnet-Public-${count.index+1}"
  }
}

#Create Subnet - Private
resource "aws_subnet" "private" {
  count             = length(var.subnets_private)
  vpc_id            = aws_vpc.vpc-final.id
  cidr_block        = element(var.subnets_private,count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Subnet-Private-${count.index+1}"
  }
}

#Create Route Table - Public
resource "aws_route_table" "route-table-public" {
  vpc_id = aws_vpc.vpc-final.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-final.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

#Create Route Table Association - Public
resource "aws_route_table_association" "rta-public" {
  count          = length(var.subnets_public)
  subnet_id      = element(aws_subnet.public.*.id,count.index)
  route_table_id = aws_route_table.route-table-public.id
}

#Create Route Table Association - Private
resource "aws_route_table_association" "rta-private" {
  count          = length(var.subnets_private)
  subnet_id      = element(aws_subnet.private.*.id,count.index)
  route_table_id = aws_route_table.route-table-public.id
}