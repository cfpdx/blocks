##################################################################
# Application Load Balancers
##################################################################

locals {
  alb_name = "${var.application_prefix}-prod-${var.default_region}-alb"
}

module "alb" {
  source = "../../modules/loadbalancers/application"

  name = local.alb_name

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  # Attach security groups
  security_groups = [module.vpc.default_security_group_id]
  # Attach rules to the created security group
  security_group_rules = {
    ingress_all_http = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP web traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress_all_https = {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS web traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      target_group_index = 0
    }
  ]

  https_listener_rules = [
    {
      https_listener_index = 0
      priority             = 1
      actions = [{
        type         = "fixed-response"
        content_type = "text/plain"
        status_code  = 200
        message_body = "ALB Healthy for ${var.registered_domain}"
      }]

      conditions = [{
        path_patterns = ["/alb_health"]
      }]
    },
    {
      https_listener_index = 0
      priority             = 2
      actions = [{
        type               = "forward"
        target_group_index = 0
      }]
      conditions = [{
        path_patterns = ["*"]
      }]
    }
  ]

  target_groups = [
    {
      name                              = "web-tg"
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      health_check = {
        enabled             = true
        interval            = 45
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 30
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id = aws_instance.web.id
          port      = 80
        }
      }
    }
  ]
}
