locals {
    acl = "private"
    bucket_name = "shared_storage_tfstate"
}

resource "aws_s3_bucket" "shared_storage_tfstate" {
    bucket = local.bucket_name
    acl    = local.acl
}