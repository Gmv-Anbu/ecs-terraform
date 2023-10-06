provider "aws" {
  profile = "staynex-prod"
  region  = var.region
}


provider "sops" {}