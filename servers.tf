

resource "aws_security_group" "server" {
  name        = "youtube-server"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.youtube.id

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

resource "aws_instance" "youtube_srv" {
  ami                    = "ami-456871456"
  instance_type          = var.server_type
  subnet_id              = aws_subnet.youtube_sub1.id
  vpc_security_group_ids = [aws_security_group.server.id]

  associate_public_ip_address = var.include_ipv4
  tags = {
    Name = "HelloWorld"
  }
}