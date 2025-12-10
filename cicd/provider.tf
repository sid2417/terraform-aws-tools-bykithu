terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.16.0"
    }
  }

  backend "s3" {
    bucket = "terraform-cicd-jenkins-master"
    key    = "terraform-cicd-jenkins-remotestate"
    region = "us-east-1"
    dynamodb_table = "terraform-cicd-jenkins-locking"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}