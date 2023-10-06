terraform {
  backend "s3" {
    bucket         = "staynex-prod-terraform-state"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "ap-southeast-1"
    dynamodb_table = "staynex-terraform-state-lock"
  }
}
