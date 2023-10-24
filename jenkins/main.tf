# VPC

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Jenkins-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.azs.names
  public_subnets = var.public_subnet_cidr

  enable_dns_hostnames = true

  tags = {

    Name        = "Jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {

    Name = "Jenins_public_subnet"
  }


}

# Security group 

module "Jenkins_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service"
  description = "publicly open"
  vpc_id      = module.vpc.vpc_id


  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },

    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH protocol"
      cidr_blocks = "0.0.0.0/0"
    }

  ]

  egress_with_cidr_blocks = [

    {

      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {

    Name = "Jenkins-sg"
  }
}

# Create Ec2 using modules 

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "Jenkins_server"

  instance_type          = var.instance_type
  key_name               = "jenkins_key"
  monitoring             = true
  vpc_security_group_ids = [module.Jenkins_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true 
  user_data = file("jenkins-install.sh")
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = {

    Name        = "Jenkins_server"
    Terraform   = "true"
    Environment = "dev"
  }
}