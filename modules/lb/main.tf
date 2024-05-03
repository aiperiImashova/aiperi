resource "aws_lb" "alb" { 
  name= var.alb_name 
  internal= false 
  load_balancer_type = "application" 
  subnets =  var.subnets
  # security_groups = var.sgroup
 
  tags = { 
    "Name"="${var.alb_name}-alb" 
  } 
} 


 
resource "aws_lb_target_group" "tg" { 
  port= 80 
  protocol= "HTTP" 
  vpc_id = var.vpc 
  target_type = "instance" 
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
  }
} 
 
resource "aws_autoscaling_attachment" "autoscaling_attachment" {
  autoscaling_group_name = var.autoscaling_group_id
  lb_target_group_arn   = aws_lb_target_group.tg.arn

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "listener" { 
  load_balancer_arn = aws_lb.alb.arn 
  port= "80" 
  protocol = "HTTP" 
 
  default_action { 
    type= "forward" 
    target_group_arn = aws_lb_target_group.tg.arn 
  } 
}
