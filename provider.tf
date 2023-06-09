provider "aws" {
  region  = "ap-south-1" # Don't change the region
}

# Add your S3 backend configuration here

resource "aws_s3_bucket" "3.devops.candidate.exam" {
  bucket = "tfstate"
     
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "3.devops.candidate.exam" {
    bucket = aws_s3_bucket.3.devops.candidate.exam.id

    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "locking"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}