variable "vpc_cidr" {
  description = "This is cidr for vpc"
  type        = string
}


variable "public_subnet_cidr" {
  description = "public subnet cidr"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "private subnet cidr"
  type        = list(string)
}