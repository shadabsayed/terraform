resource "aws_security_group" "project-sg" {
  name        = "project-sg"
  description = "Allow port 22 from anywhere"
  vpc_id = aws_vpc.project_vpc.id 
  
  ingress {
    description      = "Allow port 22 from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    description      = "Allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
