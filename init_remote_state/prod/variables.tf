variable "region" {
  description = "Region where resources are deployed"
  default     = "ap-southeast-1"
}

variable "aws_terraform_s3_bucket_name" {
  description = "AWS S3 bucket name for state file"
  type        = string
  default     = "staynex-prod-terraform-state"
}

variable "aws_terraform_dynamodb_table_name" {
  description = "AWS Dynamo DB Table name for state file lock"
  type        = string
  default     = "staynex-terraform-state-lock"
}

variable "encryption_algorithm" {
  description = "encrytion algorithm for terraform state"
  type        = string
  default     = "AES256"
}
