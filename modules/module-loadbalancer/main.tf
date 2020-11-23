#Creating Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Application LB SG"
  vpc_id      = "${var.VPC_ID}"
  tags = {
    Name = var.ALB_SG_Name
  }
}

#Creating Application LoadBaalancer
resource "aws_lb" "ALB" {
  name               = "Eig-ApplicationLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["${var.Subnet_1}","${var.Subnet_2}"]

  enable_deletion_protection = true

  tags = {
    Name = var.ALB_Name
    Environment = var.Environment_Name
  }
}

#Creating ALB Target Group
resource "aws_lb_target_group" "alb_target" {  
  name     = "${var.target_group_name}"  
  port     = "${var.alb_target_port}"  
  protocol = "HTTP"  
  vpc_id   = "${var.VPC_ID}"   
  tags = {    
    name = "${var.target_group_name}"    
  }   
  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "${var.target_helth_path}"    
    port                = "${var.target_helth_port}"  
  }
}

#Creating ALB Listener
resource "aws_lb_listener" "alb_listener" {  
  load_balancer_arn = "${aws_lb.ALB.arn}"  
  port              = "${var.alb_listener_port}"  
  protocol          = "${var.alb_listener_protocol}"
  
  default_action {    
    target_group_arn = "${aws_lb_target_group.alb_target.arn}"
    type             = "forward"  
  }
}
