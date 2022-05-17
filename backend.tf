terraform {
  backend "s3" {
    bucket         = "shared-storage-terraform-state-dev"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}