variable "server_type" {
  type        = string
  description = "Instance type"
  default     = "t3.micro"
}

variable "server_count" {
  type        = number
  description = "Instance name"
  default     = 1
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