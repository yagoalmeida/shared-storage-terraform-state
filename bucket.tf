resource "aws_s3_bucket" "shared-storage-terraform-state" {
  bucket = "shared-storage-terraform-state-dev"
}

resource "aws_s3_bucket_acl" "shared-storage-terraform-state-acl" {
  bucket = aws_s3_bucket.shared-storage-terraform-state.id
  acl    = "private"
}

resource "aws_s3_bucket" "log-bucket" {
  bucket = "log-bucket"
}

resource "aws_s3_bucket_acl" "log-bucket-acl" {
  bucket = aws_s3_bucket.log-bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "log-bucket-logging" {
  bucket = aws_s3_bucket.shared-storage-terraform-state.id

  target_bucket = aws_s3_bucket.log-bucket.id
  target_prefix = "log/"
}