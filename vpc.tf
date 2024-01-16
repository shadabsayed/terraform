#vpc code 

resource "aws_vpc" "project_vpc" {
 cidr_block = "10.1.0.0/16"
 enable_dns_support = true
 enable_dns_hostname = true

 tag = {
   Name = "project-vpc"
 }
}

resource "aws_subnet" "project-public-subnet-1" {
 vpc_id                  = aws_vpc.project_vpc.id
 cidr_block              = "10.1.1.0/24"
 availability_zone       = "ap-south-1a"
 map_public_ip_on_launch = true

 tag = {
  Name = "public-subnet-1"
 }
}

resource "aws_subnet" "project-public-subnet-2" {
 vpc_id                  = aws_vpc.project_vpc.id
 cidr_block              = "10.1.2.0/24"
 availability_zone       = "ap-south-1b"
 map_public_ip_on_launch = true

 tag = {
  Name = "public-subnet-2"
 }
}

resource "aws_subnet" "project-private-subnet-1" {
 vpc_id                  = aws_vpc.project_vpc.id
 cidr_block              = "10.1.3.0/24"
 availability_zone       = "ap-south-1a"

 tag = {
  Name = "private-subnet-1"
 }
}

resource "aws_subnet" "project-private-subnet-2" {
 vpc_id                  = aws_vpc.project_vpc.id
 cidr_block              = "10.1.4.0/24"
 availability_zone       = "ap-south-1b"

 tag = {
  Name = "private-subnet-2"
 }
}

#2 database subnets
resource "aws_subnet" "project-database-subnet-1" {
 vpc_id                  = aws_vpc.project_vpc.id
 cidr_block              = "10.1.5.0/24"
 availability_zone       = "ap-south-1a"

 tag = {
  Name = "database-subnet-1"
 }
}

resource "aws_subnet" "project-database-subnet-2" {
 vpc_id                  = aws_vpc.database_vpc.id
 cidr_block              = "10.1.6.0/24"
 availability_zone       = "ap-south-1b"

 tag = {
  Name = "database-subnet-2"
 }
}

#Internet gateway
resource "aws_internet_gateway" "project_igw" {
 vpc_id = aws_vpc.project_vpc.id
 tag = {
  Name = "project-igw"
 }
}
#Elastic IP for NAT
resources "aws_eip "nat_eip" {
  vpc = true
}

#Nat gateway
resource "aws_nat_gateway" "project-nat-gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.project-public-subnet-1.id
  tag = {
    Name = "project-nat-gw"
  }
  depends_on = [aws_internet_gateway.project_igw]
}

#Public route table
#Public subnet association
#Adding Internet gateway to public route table
#PUBLIC ROUTE TABLE
resource "aws_route_table" "project-public-rt" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
   "Name" = "public-rt"
  }
}

#ASSOCIATION OF PUBLIC SUBNET WITH PUBLIC ROUTE TABLE
resource "aws_route_table_association" "public_subnet_association-1" {
  route_table_id = aws_route_table.project-public-rt.id
  subnet_id      = aws_subnet.project-public-subnet-1.id
}

resource "aws_route_table_association" "public_subnet_association-2" {
  route_table_id = aws_route_table.project-public-rt.id
  subnet_id      = aws_subnet.project-public-subnet-2.id
}

#ADDITION OF IGW INTO PUBLIC ROUTE TABLE
resource "aws_route" "project-route-igw" {
  route_table_id         = aws_route_table.project-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.project_igw.id
}

#PRIVATE route table
#PRIVATE subnet association
#Adding NAT gateway to PRIVATE route table
#PRIVATE ROUTE TABLE
resource "aws_route_table" "project-private-rt" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
   "Name" = "private-rt"
  }
}

#ASSOCIATION OF PRIVATE SUBNET WITH PRIVATE ROUTE TABLE
resource "aws_route_table_association" "private_subnet_association-1" {
  route_table_id = aws_route_table.project-private-rt.id
  subnet_id      = aws_subnet.project-private-subnet-1.id
}

resource "aws_route_table_association" "private_subnet_association-2" {
  route_table_id = aws_route_table.project-private-rt.id
  subnet_id      = aws_subnet.project-private-subnet-2.id
}

#ADDITION OF NAT GATEWAY INTO PUBLIC ROUTE TABLE
resource "aws_route" "project-route-nat-gw" {
  route_table_id         = aws_route_table.project-private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.project-nat-gw.id
}

#DATABASE ROUTE TABLE
#DATABASE SUBNET ASSOCIATION WITH DATABASE ROUTE TABLE
#database route table
resource "aws_route_table" "project-database-rt" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
   "Name" = "database-rt"
  }
}

#ASSOCIATION OF DATABASE SUBNET WITH DATABASE ROUTE TABLE
resource "aws_route_table_association" "database_subnet_association-1" {
  route_table_id = aws_route_table.project-database-rt.id
  subnet_id      = aws_subnet.project-database-subnet-1.id
}

resource "aws_route_table_association" "database_subnet_association-2" {
  route_table_id = aws_route_table.project-database-rt.id
  subnet_id      = aws_subnet.project-database-subnet-2.id
}
