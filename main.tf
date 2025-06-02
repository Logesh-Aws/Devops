# It was the providers which want infra we are going to work
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0-beta2"
    }
    google = {
      source = "hashicorp/google"
      version = "6.37.0"
    }
  }
}

# Below is the which region we have to create a resource

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

# It shows the VPC configuration details 
resource "aws_vpc" "VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "My-VPC"
  }
}

# The subnet creation for the VPC

resource "aws_subnet" "Public-Subnet" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Pub-Subnet"
  }
}

resource "aws_subnet" "Private-Subnet" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Priv-Subnet"
  }
}

# Route table details

resource "aws_route_table" "Public-Route-Table" {
  vpc_id = aws_vpc.VPC.id

  # route = []

  tags = {
    Name = "Pub-Route-Table"
  }
}

resource "aws_route_table" "Private-Route-Table" {
  vpc_id = aws_vpc.VPC.id

  route = []

  tags = {
    Name = "Pvt-Route-Table"
  }
}


# Internet gateway details

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "IGW"
  }
}

# Elastic IP for NAT gateway 

resource "aws_eip" "eip" {
  #instance = aws_instance.web.id
  domain   = "vpc"
}

# Nat Gateway creation

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