resource "aws_security_group" "public_sg" {
  name        = "security"
  vpc_id      = aws_vpc.my_vpc.id
  description = "allow ssh"

  tags = {
    Name = "pub_sg"
  }

  ingress {
    description = "Allow port 22 from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all egress traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# for private ----

resource "aws_security_group" "private_sg" {
  name        = "pvt_sg"
  vpc_id      = aws_vpc.my_vpc.id
  description = "port 22 & 80"

  tags = {
    name = "pvt_sg"
  }

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all egress traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# for load balancer---

resource "aws_security_group" "load_sg" {
  name        = "load_sg"
  vpc_id      = aws_vpc.my_vpc.id
  description = "port 80 & 443"

  tags = {
    name = "ALB_sg"
  }

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all egress traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# for RDS ----

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  vpc_id      = aws_vpc.my_vpc.id
  description = "port 3306"

  tags = {
    name = "rds_group"
  }

  ingress {
    description      = "mysql access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.private_sg.id]
  }

  egress {
    description      = "Allow all egress traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
