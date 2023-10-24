terraform {
  backend "s3" {
    bucket = "terraform-eks-demo-project-statefile"
    key    = "jenkins_statefile/terraform.tfstate"
    region = "us-west-2"
  }

}