#vpc code 

resource "aws_vpc" "project_vpc" {
 cidr_block = "10.1.0.0/16"
 enable_dns_support = true
 enable_dns_hostname = true

 tag = {
   Name = "project-vpc"
 }
}

resource "aws_subnet" "skyage-public-subnet-1" {
 vpc_id                  = aws_vpc.project_vpc.id
 cidr_block              = "10.1.1.0/24"
 availability_zone       = "ap-south-1a"
 map_public_ip_on_launch = true

 tag = {
  Name = "public-subnet-1"
 }
}

