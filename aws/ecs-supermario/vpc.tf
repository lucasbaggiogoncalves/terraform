resource "aws_vpc" "mario" {
  cidr_block = var.cidr_block.vpc

  tags = {
    "Name" = var.tags.vpc
  }
}

resource "aws_internet_gateway" "mario" {
  vpc_id = aws_vpc.mario.id

  tags = {
    Name = var.tags.igw
  }
}

resource "aws_subnet" "mario-public" {
  vpc_id            = aws_vpc.mario.id
  cidr_block        = var.cidr_block.subnet
  availability_zone = var.availability_zone

  tags = {
    "Name" = var.tags.subnet
  }
}

resource "aws_route_table" "mario" {
  vpc_id = aws_vpc.mario.id

  route {
    cidr_block = var.cidr_block.internet
    gateway_id = aws_internet_gateway.mario.id
  }

  tags = {
    Name = var.tags.rt
  }
}

resource "aws_route_table_association" "mario-public-us-east-1a" {
  subnet_id      = aws_subnet.mario-public.id
  route_table_id = aws_route_table.mario.id
}