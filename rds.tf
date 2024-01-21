resource "aws_db_subnet_group" "subnet_group" {
  name        = "example-subnet-group"
  description = "Example DB Subnet Group"
  subnet_ids  = [aws_subnet.DB_subnet_1.id, aws_subnet.DB_subnet_2.id]

  tags ={ 
    Name = "subnet_group"
  }
}


resource "aws_db_instance" "db_instance" {
  identifier               = "db-instance"
  engine                   = "mysql"  # Change to your desired database engine
  db_name                  = "db_instance"
  username                 = "admin"
  password                 = "password"
  instance_class           = "db.t3.micro"
  allocated_storage        = 20
  storage_type             = "gp2"
  db_subnet_group_name     = aws_db_subnet_group.subnet_group.id
  publicly_accessible      = false
  multi_az                 = false
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  availability_zone        = "ap-south-1a"
  port                     = "3306"
  skip_final_snapshot      = true
  delete_automated_backups = true

  # Other database instance settings can be added as needed

  tags = {
    Name = "DBInstance"
  }
}
