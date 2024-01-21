# Create a target group for both private and database instances
resource "aws_lb_target_group" "target_group" {
  target_type = "instance"
  name        = "target-group"
  port        = "80"  # Assuming your instances are running on port 80
  vpc_id      = aws_vpc.my_vpc.id
  protocol    = "HTTP"
  

  health_check {
    path = "/"
    port = "80"
  }
}

# Register private instances with the combined target group
resource "aws_lb_target_group_attachment" "private_tg" {
  target_group_arn  = aws_lb_target_group.target_group.arn
  target_id         = aws_instance.private_instance.id
  port              = "80"
}

# Register database instances with the combined target group
resource "aws_lb_target_group_attachment" "db_tg" {
  target_group_arn  = aws_lb_target_group.target_group.arn
  target_id         = aws_instance.db_instance.id
  port              = "80"
}


# Create the Application Load Balancer
resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_sg.id]  # Attach the load balancer security group
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]  # Use public subnets

  enable_deletion_protection = false  # Set to true if you want to enable deletion protection

  enable_cross_zone_load_balancing   = true
  idle_timeout                       = 400
  enable_http2                       = true

  tags = {
    Name = "my_Alb"
  }
}

# Add a listener to the load balancer
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}
