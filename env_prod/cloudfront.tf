# # ACM certificates required

# # Admin Frontend
# resource "aws_cloudfront_distribution" "website_admin" {
#   origin {
#     domain_name = aws_s3_bucket.s3_bucket_admin.website_endpoint
#     origin_id   = "s3-origin"
#   }

#   enabled             = true
#   is_ipv6_enabled     = true
#   default_root_object = "index.html"

#   aliases = ["<your_cloudfront_domain>"]

#   default_cache_behavior {
#     target_origin_id = "s3-origin"

#     viewer_protocol_policy = "redirect-to-https"

#     allowed_methods = ["GET", "HEAD", "OPTIONS"]
#     cached_methods  = ["GET", "HEAD"]

#     min_ttl     = 0
#     default_ttl = 3600
#     max_ttl     = 86400
#     compress    = true
#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     acm_certificate_arn = "<your_acm_certificate_arn>"
#     ssl_support_method  = "sni-only"
#   }
# }

# output "cloudfront_domain_name" {
#   value = aws_cloudfront_distribution.website_admin.domain_name
# }

# output "s3_bucket_endpoint" {
#   value = aws_s3_bucket.s3_bucket_admin.website_endpoint
# }

# # User Frontend
# resource "aws_cloudfront_distribution" "website_user" {
#   origin {
#     domain_name = aws_s3_bucket.s3_bucket_user.website_endpoint
#     origin_id   = "s3-origin"
#   }

#   enabled             = true
#   is_ipv6_enabled     = true
#   default_root_object = "index.html"

#   aliases = ["<your_cloudfront_domain>"]

#   default_cache_behavior {
#     target_origin_id = "s3-origin"

#     viewer_protocol_policy = "redirect-to-https"

#     allowed_methods = ["GET", "HEAD", "OPTIONS"]
#     cached_methods  = ["GET", "HEAD"]

#     min_ttl     = 0
#     default_ttl = 3600
#     max_ttl     = 86400
#     compress    = true
#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     acm_certificate_arn = "<your_acm_certificate_arn>"
#     ssl_support_method  = "sni-only"
#   }
# }

# output "cloudfront_domain_name_user" {
#   value = aws_cloudfront_distribution.website_user.domain_name
# }

# output "s3_bucket_endpoint_user" {
#   value = aws_s3_bucket.s3_bucket_user.website_endpoint
# }
