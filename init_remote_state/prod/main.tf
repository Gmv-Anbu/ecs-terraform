terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.31.0"
    }
  }
  #  required_version = "~> 0.14"
}

provider "aws" {
  profile = "staynex-prod"
  region  = var.region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.aws_terraform_s3_bucket_name

}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = var.aws_terraform_s3_bucket_name
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = var.aws_terraform_s3_bucket_name

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.encryption_algorithm
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.aws_terraform_dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
