
resource "aws_cloudfront_distribution" "website_admin" {
  origin {
    domain_name = aws_s3_bucket.s3_bucket_admin.bucket_regional_domain_name
    origin_id   = "s3-origin"
    # origin_access_control_id = aws_cloudfront_origin_access_control.website_admin_oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  #   aliases = ["<your_cloudfront_domain>"]

  default_cache_behavior {
    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
    compress    = true
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [aws_s3_bucket.s3_bucket_admin]
}