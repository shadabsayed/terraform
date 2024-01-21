# Public Instance
resource "aws_instance" "public_instance" {
  ami             = "ami-0c84181f02b974bc3"  # Specify the appropriate AMI ID
  instance_type   = "t2.micro"  # Specify the desired instance type
  subnet_id       = aws_subnet.public_subnet_1.id  # Use the public subnet
  security_groups = [aws_security_group.public_sg.id]  # Attach the public security group
  key_name        = "publickey"  # Specify your key pair name
  
  tags = {
    Name = "public_instance"
  }
}

# Private Instance
resource "aws_instance" "private_instance" {
  ami             = "ami-0c84181f02b974bc3"  # Specify the appropriate AMI ID
  instance_type   = "t2.micro"  # Specify the desired instance type
  subnet_id       = aws_subnet.private_subnet_1.id  # Use the private subnet
  security_groups = [aws_security_group.private_sg.id]  # Attach the private security group
  key_name        = "pvtkey"  # Specify your key pair name

  user_data = <<-EOF
             #!/bin/bash
             sudo yum update -y 
             sudo yum install httpd -y
             sudo systemctl start httpd
             sudo systemctl enable httpd 
             cd /var/www/html
              html_content='<h1>SkyAge Global IT Services Pvt. Ltd.</h1><br><p><h3>SkyAge IT Services Pvt. Ltd. is India’s fastest growing IT Company with strong focus on Big data solutions, Cloud Computing, Machine Learning, Web Services with the best possible solutions for the clients. During today’s competitive & challenging economic world new product design & development process requires large amount of research & development efforts to deliver perfect solutions.Big Data is a big problem for all companies to manage, to use it for business growth and taking insights from the huge amount of data, we are making life simple with the help of Hadoop (All Components). Cloud Computing is very important .SkyAge IT Services Pvt. Ltd. provides total solution information technology services to enterprises, government sectors, educational institutions, auto companies, retail sector, banking & financial institutions & various industries. SkyAge team seamlessly integrates with our client’s team thereby acting as virtual extensions to their existing operations. We follow rigorous project management principles with process automation and ensure quality delivery in all our engagements. We highly skilled, dedicated IT professionals, its subsidiaries, and Joint Ventures provide customized IT solutions for several industries using our range of technical expertise and experience. Our management and research teams are putting untiring efforts in the 24-hour developmental labs, software and web professionals constantly deliver the products pertaining to the industry need, converging of all the new developmental aspects that are being introduced in the IT market.<br><button><a href="https://www.skyage.in/">CLICK HERE TO VISIT WEBSITE</a></button>'
             echo "$html_content" >> index.html
             EOF

  tags = {
    Name = "private_instance"
  }
}

# Database Instance
resource "aws_instance" "db_instance" {
  ami             = "ami-0c84181f02b974bc3"  # Specify the appropriate AMI ID
  instance_type   = "t2.micro"  # Specify the desired instance type
  subnet_id       = aws_subnet.DB_subnet_1.id  # Use the database subnet
  security_groups = [aws_security_group.rds_sg.id]  # Attach the RDS security group
  key_name        = "pvtkey"  # Specify your key pair name
  tags = {
    Name = "db_instance"
  }
}
