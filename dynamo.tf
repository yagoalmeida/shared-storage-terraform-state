resource "aws_dynamodb_table" "terraform_state_lock" {
  depends_on     = [aws_kms_key.kms]
  name           = "terraform-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.kms.arn
  }
  point_in_time_recovery {
    enabled = true
  }
}