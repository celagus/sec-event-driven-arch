terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " 4.24.0"
    }
  }
#  backend "s3" {
#    bucket = "<your-bucket-here>"
#    key    = "sec-event-driven-arch/us-east-1"
#    region = "us-east-1"
#  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment  = "Lab"
    }
  }
}