
resource "aws_security_group" "server" {
  name        = "youtube-server"
  description = "Allow inbound traffic"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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

resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "server" {
  key_name   = "youtube"
  public_key = tls_private_key.server.public_key_openssh
}

resource "aws_instance" "public_server" {
  count                  = var.public_server_count
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.server.key_name
  instance_type          = var.server_type
  subnet_id              = module.network.public_subnets[count.index]
  vpc_security_group_ids = [aws_security_group.server.id]

  associate_public_ip_address = var.include_ipv4
  tags = {
    Name = "PublicServer-${count.index}"
  }
}


resource "aws_security_group" "web_server" {
  name        = "youtube-web-server"
  description = "Allow inbound traffic"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "private_server" {
  count         = var.private_server_count
  ami           = data.aws_ami.ubuntu.id
  key_name      = aws_key_pair.server.key_name
  instance_type = var.server_type
  subnet_id     = module.network.private_subnets[count.index]
  vpc_security_group_ids = [
    aws_security_group.server.id,
    aws_security_group.web_server.id
  ]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
  tags = {
    Name = "PrivateServer-${count.index}"
  }
}

resource "aws_lb" "youtube" {
  name               = "${local.lb_name}-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_server.id]
  subnets            = module.network.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "${local.lb_name}-tf"
  }
}

resource "aws_lb_target_group" "youtube" {
  name     = "${local.lb_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
}

resource "aws_lb_listener" "youtube" {
  load_balancer_arn = aws_lb.youtube.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.youtube.arn
  }

}

resource "aws_lb_listener_rule" "youtube" {
  listener_arn = aws_lb_listener.youtube.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.youtube.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_lb_target_group_attachment" "youtube" {
  count            = var.private_server_count
  target_group_arn = aws_lb_target_group.youtube.arn
  target_id        = aws_instance.private_server[count.index].id
  port             = 80
}
