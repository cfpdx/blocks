##################################################################
# Compute
##################################################################

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
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

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.primary_public.id
  vpc_security_group_ids      = [aws_security_group.allow_alb.id]
  key_name                    = "backdoor_web"
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
# Update the package manager and install Nginx
sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
# Create an HTML file to display the public IPv4 address
printf '<html><body><h1>Hello, From ' > /var/www/html/index.html
curl -s http://169.254.169.254/latest/meta-data/public-ipv4 >> /var/www/html/index.html
printf '!</h1></body></html>' >> /var/www/html/index.html
sudo systemctl restart nginx
EOF

  tags = {
    Name = "Hello World"
  }
}
