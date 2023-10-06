resource "aws_acm_certificate" "backend_api" {
  domain_name       = "api.voting.staynex.com"
  validation_method = "DNS"

  tags = {
    name        = "api.voting.staynex.com"
    Environment = "prod"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "user_fe" {
  domain_name       = "voting.staynex.com"
  validation_method = "DNS"

  tags = {
    name        = "admin.voting.staynex.com"
    Environment = "prod"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "admin_fe" {
  domain_name       = "admin.voting.staynex.com"
  validation_method = "DNS"

  tags = {
    name        = "admin.voting.staynex.com"
    Environment = "prod"
  }

  lifecycle {
    create_before_destroy = true
  }
}