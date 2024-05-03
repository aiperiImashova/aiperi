
resource "aws_launch_template" "foobar" { 
  name_prefix   = var.name_prefix 
  instance_type = var.instance_type 
  image_id = data.aws_ami.amazon_linux.id
  key_name      = "aiperi-key" 
 
  vpc_security_group_ids = var.sg 
 
  user_data = var.private_subnets != [] ? filebase64("${path.module}/script.sh") : null 
 
  block_device_mappings { 
    device_name = "/dev/xvda" 
    ebs { 
      volume_size = 100 
      delete_on_termination = true 
    } 
  }
  tags = {
    Name = "aiko"
  }
}

resource "aws_autoscaling_group" "bar" {
  desired_capacity   = var.desired_size
  max_size           = var.max_size
  min_size           = var.min_size
  vpc_zone_identifier = var.private_subnets
  health_check_type    = var.health_check_type
  health_check_grace_period      = 300
  target_group_arns = var.tg_arn

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}




