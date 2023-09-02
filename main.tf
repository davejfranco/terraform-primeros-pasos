variable "instance_type" {
  type        = string # bool, number, list, map, object, set, string, tuple
  description = "Instance type"
  default     = "c5.large"
}

output "web_id" {
  value = aws_instance.web.arn
}

data "aws_region" "current" {}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe235"
  instance_type = var.instance_type
}

resource "aws_instance" "web1" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
}

output "region" {
  value = data.aws_region.current.name
}

