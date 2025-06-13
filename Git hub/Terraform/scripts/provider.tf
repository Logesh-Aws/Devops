terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta2"
    }
    google = {
      source  = "hashicorp/google"
      version = "6.37.0"
    }
  }

  backend "s3" {
    bucket  = "bucket.00-test"
    key     = "Terraform/statefile"
    region  = "ap-south-1"
    profile = "Logeshwaran"
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "Logeshwaran"
}

