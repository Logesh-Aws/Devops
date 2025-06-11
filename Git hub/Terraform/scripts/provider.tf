provider "aws" {
  region  = "ap-south-1"       # Change to your desired AWS region
  profile = "default"         # Optional: if using a named profile from ~/.aws/credentials
}

terraform {
  backend "s3" {
    bucket = "bucket.00-test"
    key    = "Terraform/statefile"
    region = "ap-south-1"
  }
}
