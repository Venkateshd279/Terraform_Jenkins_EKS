terraform {
  backend "s3" {
    bucket = "terraform-eks-demo-project-statefile"
    key    = "eks_statefile/terraform.tfstate"
    region = "us-west-2"
  }
}