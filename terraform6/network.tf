resource "aws_vpc" "main_sk" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-sk"
  }
}

resource "aws_internet_gateway" "igw_sk" {
  vpc_id = aws_vpc.main_sk.id

  tags = {
    Name = "igw-sk"
  }
}

resource "aws_subnet" "public_subnet_sk" {
  vpc_id                  = aws_vpc.main_sk.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1-sk"
  }
}

resource "aws_subnet" "public_subnet_2_sk" {
  vpc_id                  = aws_vpc.main_sk.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2-sk"
  }
}

resource "aws_route_table" "public_rt_sk" {
  vpc_id = aws_vpc.main_sk.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_sk.id
  }

  tags = {
    Name = "public-rt-sk"
  }
}

resource "aws_route_table_association" "rt_assoc_1_sk" {
  subnet_id      = aws_subnet.public_subnet_sk.id
  route_table_id = aws_route_table.public_rt_sk.id
}

resource "aws_route_table_association" "rt_assoc_2_sk" {
  subnet_id      = aws_subnet.public_subnet_2_sk.id
  route_table_id = aws_route_table.public_rt_sk.id
}
