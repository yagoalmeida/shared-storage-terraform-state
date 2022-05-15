resource "aws_s3_bucket" "shared-storage-terraform-state" {
  bucket = "shared-storage-terraform-state-dev"
  acl    = "private"
}