terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "kwashingtontf"
  default_tags {
    tags = {
        Name = "Team-Helm"
    }
  }  
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
#   tags = {
#     Name = "washington"
#   }
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = var.AZ[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Team-Helm-${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Team-Helm-igw"
  }
}

resource "aws_eip" "nat-eip" {
  domain   = "vpc"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Team-Helm-public-rt"
  }
}

resource "aws_route_table_association" "public-rt" {
  count = var.public_subnet_count
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}



