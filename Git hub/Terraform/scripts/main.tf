terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta2"
    }
    google = {
      source  = "hashicorp/google"
      version = "6.37.0"
    }
  }
}

# VPC creation region

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}

# VPC Name
resource "aws_vpc" "VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "My-VPC"
  }
}

# Subnet creation

# Public Subnet
resource "aws_subnet" "Public-Subnet" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Pub-Subnet"
  }
}

# Private subnet
resource "aws_subnet" "Private-Subnet" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Priv-Subnet"
  }
}

# Route Table

# public route table 
resource "aws_route_table" "Public-Route-Table" {
  vpc_id = aws_vpc.VPC.id

  # route = []

  tags = {
    Name = "Pub-Route-Table"
  }
}

# Private route table
resource "aws_route_table" "Private-Route-Table" {
  vpc_id = aws_vpc.VPC.id

  route = []

  tags = {
    Name = "Pvt-Route-Table"
  }
}

# Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "IGW"
  }
}

# Elastic IP
resource "aws_eip" "eip" {
  #instance = aws_instance.web.id
  domain = "vpc"
}

# Nat Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.Public-Subnet.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  # depends_on = [aws_internet_gateway.example]
}

# Route table association

resource "aws_route_table_association" "Public-route-table" {
  subnet_id      = aws_subnet.Public-Subnet.id
  route_table_id = aws_route_table.Public-Route-Table.id
}


resource "aws_route_table_association" "Private-route-table" {
  subnet_id      = aws_subnet.Private-Subnet.id
  route_table_id = aws_route_table.Private-Route-Table.id
}


resource "aws_route" "r" {
  route_table_id         = aws_route_table.Public-Route-Table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "r1" {
  route_table_id         = aws_route_table.Private-Route-Table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id # = aws_nat_gateway.nat.id
}