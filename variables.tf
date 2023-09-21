variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "server_type" {
  type        = string
  description = "Instance type"
  default     = "t3.micro"
}

variable "public_server_count" {
  type        = number
  description = "Instance count"
  default     = 1
}

variable "private_server_count" {
  type        = number
  description = "Instance count"
  default     = 3
}

variable "create_igw" {
  type        = bool
  description = "Instance name"
  default     = true
}

variable "include_ipv4" {
  type    = bool
  default = true
}

#variables types
#string
#number
#bool
#list
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}