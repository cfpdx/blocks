##################################################################
# Compute
##################################################################

locals {
  # Obviously not the ideal way of doing this but it works for now
  maintanence_msg = <<EOF
#!/bin/bash
# Update the package manager and install Nginx
sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
printf '<html><body>' > /var/www/html/index.html
printf '<h1>This site is currently under maintenance</h1>' >> /var/www/html/index.html
printf '<h2>We apologize for any inconvenience.</h2>' >> /var/www/html/index.html
printf '<a target="_blank" rel="noopener noreferrer" href="https://www.linkedin.com/in/trevor-johnson12/">Contact Administrator</a>' >> /var/www/html/index.html
printf '<h3>In the meantime...</h3>' >> /var/www/html/index.html
printf '<a target="_blank" rel="noopener noreferrer" href="https://assets.codefriendspdx.com/contributors/trevorjohnson/projects/spacehunt/SpaceHunt/index.html">SpaceHunt?</a>' >> /var/www/html/index.html
printf '</body></html>' >> /var/www/html/index.html
sudo systemctl restart nginx
EOF
}

data "aws_caller_identity" "current" {}

data "aws_ami" "cfpdx_web" {
  most_recent = true

  filter {
    name   = "name"
    values = ["cfpdx-web"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [data.aws_caller_identity.current.account_id]
}

data "aws_subnet" "primary_public" {
  id = module.vpc.public_subnets[0]
}

resource "aws_security_group" "allow_alb" {
  name        = "allow_alb"
  description = "Allow ALB inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Ingress rule allowing HTTP from the ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [module.alb.security_group_id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.application_prefix}-web-allow-alb-sg"
  }
}

## ASG
resource "aws_launch_template" "web_asg_template" {
  name = "cfpdx-web-template"

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 30
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.allow_alb.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.application_prefix}-web-instance"
    }
  }

  image_id = data.aws_ami.cfpdx_web.id
  instance_type = "t2.micro"       # Change to your desired instance type
  key_name = "backdoor_web"
}

resource "aws_autoscaling_group" "web_asg" {
  name          = "${var.application_prefix}-web-asg"

  launch_template {
    id = aws_launch_template.web_asg_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = [data.aws_subnet.primary_public.id]
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  
  target_group_arns = module.alb.target_group_arns
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  alarm_name          = "web-cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  alarm_description = "Scale up the Auto Scaling Group when CPU utilization is high"
  alarm_actions    = [aws_autoscaling_policy.web_asg_scale_up_policy.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_low" {
  alarm_name          = "web-cpu-utilization-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30

  alarm_description = "Scale down the Auto Scaling Group when CPU utilization is low"
  alarm_actions    = [aws_autoscaling_policy.web_asg_scale_down_policy.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

resource "aws_autoscaling_policy" "web_asg_scale_up_policy" {
  name                   = "scale-up-policy"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name

  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown = 300
}

resource "aws_autoscaling_policy" "web_asg_scale_down_policy" {
  name                   = "scale-down-policy"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name

  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown = 300
}
