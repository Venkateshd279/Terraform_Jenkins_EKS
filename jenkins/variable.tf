variable "vpc_cidr" {
  description = "This is cidr for vpc"
  type        = string
}


variable "public_subnet_cidr" {
  description = "public subnet cidr"
  type        = list(string)
}

variable "instance_type" {
  type        = string
  description = "Instance type specify here"
}
