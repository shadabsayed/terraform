#DB SUBNET GROUP CREATE
resource "aws_db_subnet_group" "db_sub_group" {
  name = "db-subnet-group"
  description = "db-subnet-group-for-rds-server"
  subnet_ids = [aws_subnet.project-database-subnet-1.id, aws_subnet.project-database-subnet-1.id]
  tags ={
    Name = "My-DB-subgrp"
    }
}
