
provider "aws" {
  access_key = 
  secret_key = 
  region = "ap-south-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block          = "10.0.0.0/16"
  enable_dns_support  = true
  enable_dns_hostnames = true 

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone        = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone        = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone        = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone        = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "DB_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone        = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "DB_subnet_1"
  }
}

resource "aws_subnet" "DB_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone        = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "DB_subnet_2"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  
  tags = {
    Name = "my_igw"
  }
}

resource "aws_eip" "nat_ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnet_1.id 
  
  tags = {
    Name = "my_nat"
  }

  depends_on = [aws_internet_gateway.my_igw]

}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
 
  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_sub_association_1" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "public_sub_association_2" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_2.id
}

resource "aws_route" "route" {
  route_table_id      = aws_route_table.public_rt.id
  destination_cidr_block          = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id
}

resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.my_vpc.id
 
  tags = {
    Name = "pvt_rt"
  }
}

resource "aws_route_table_association" "pvt_sub_association_1" {
  route_table_id = aws_route_table.pvt_rt.id
  subnet_id      = aws_subnet.private_subnet_1.id
}

resource "aws_route_table_association" "pvt_sub_association_2" {
  route_table_id = aws_route_table.pvt_rt.id
  subnet_id      = aws_subnet.private_subnet_2.id
}

resource "aws_route" "nat_route" {
  route_table_id = aws_route_table.pvt_rt.id
  destination_cidr_block     = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.my_nat.id
}

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.my_vpc.id
 
  tags = {
    Name = "db_rt"
  }
}

resource "aws_route_table_association" "db_sub_association_1" {
  route_table_id = aws_route_table.db_rt.id
  subnet_id      = aws_subnet.DB_subnet_1.id
}

resource "aws_route_table_association" "db_sub_association_2" {
  route_table_id = aws_route_table.db_rt.id
  subnet_id      = aws_subnet.DB_subnet_2.id
}

