resource "aws_s3_bucket" "shared-storage-terraform-state" {
  depends_on = [aws_kms_key.kms]
  bucket     = "shared-storage-terraform-state-dev"
}

resource "aws_s3_bucket_versioning" "shared-storage-terraform-state" {
  bucket = aws_s3_bucket.shared-storage-terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "shared-storage-terraform-state" {
  bucket = aws_s3_bucket.shared-storage-terraform-state.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "shared-storage-terraform-state" {
  bucket = aws_s3_bucket.shared-storage-terraform-state.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "shared-storage-terraform-state" {
  bucket                  = aws_s3_bucket.shared-storage-terraform-state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "log-bucket" {
  depends_on = [aws_kms_key.kms]
  bucket     = "log-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log-bucket" {
  bucket = aws_s3_bucket.log-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "log-bucket" {
  bucket = aws_s3_bucket.log-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "log-bucket" {
  bucket                  = aws_s3_bucket.log-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "log-bucket" {
  bucket = aws_s3_bucket.log-bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "log-bucket" {
  bucket = aws_s3_bucket.shared-storage-terraform-state.id

  target_bucket = aws_s3_bucket.log-bucket.id
  target_prefix = "log/"
}