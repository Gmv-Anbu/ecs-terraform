# # Backend
# resource "aws_s3_bucket" "s3_bucket" {
#   bucket        = "${var.project_name}-${var.env_name}"
#   force_destroy = true
# }

# resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "bucket_acl" {
#   depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership_controls]

#   bucket = aws_s3_bucket.s3_bucket.id
#   acl    = "private"
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_server_side_encryption_configuration" {
#   bucket = aws_s3_bucket.s3_bucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.kms_key.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }

# Frontend Admin
resource "aws_s3_bucket" "s3_bucket_admin" {
  bucket        = "${var.project_name}-${var.env_name}-admin-website"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls_admin" {
  bucket = aws_s3_bucket.s3_bucket_admin.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block_admin" {
  bucket = aws_s3_bucket.s3_bucket_admin.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_bucket_acl_admin" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership_controls_admin,
    aws_s3_bucket_public_access_block.bucket_public_access_block_admin,
  ]

  bucket = aws_s3_bucket.s3_bucket_admin.id
  acl    = "public-read"
}

# resource "aws_s3_bucket_website_configuration" "bucket_website_configuration_admin" {
#   bucket = aws_s3_bucket.s3_bucket_admin.id

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }

#   # routing_rule {
#   #   condition {
#   #     key_prefix_equals = "docs/"
#   #   }
#   #   redirect {
#   #     replace_key_prefix_with = "documents/"
#   #   }
#   # }
# }

resource "aws_s3_bucket_policy" "s3_bucket_admin_policy" {
  bucket = aws_s3_bucket.s3_bucket_admin.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${aws_s3_bucket.s3_bucket_admin.arn}/*"
    }
  ]
}
EOF
}


# Frontend User
resource "aws_s3_bucket" "s3_bucket_user" {
  bucket        = "${var.project_name}-${var.env_name}-user-website"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls_user" {
  bucket = aws_s3_bucket.s3_bucket_user.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block_user" {
  bucket = aws_s3_bucket.s3_bucket_user.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_bucket_acl_user" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership_controls_user,
    aws_s3_bucket_public_access_block.bucket_public_access_block_user,
  ]

  bucket = aws_s3_bucket.s3_bucket_user.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "bucket_website_configuration_user" {
  bucket = aws_s3_bucket.s3_bucket_user.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

  # routing_rule {
  #   condition {
  #     key_prefix_equals = "docs/"
  #   }
  #   redirect {
  #     replace_key_prefix_with = "documents/"
  #   }
  # }
}

resource "aws_s3_bucket_policy" "s3_bucket_user_policy" {
  bucket = aws_s3_bucket.s3_bucket_user.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${aws_s3_bucket.s3_bucket_user.arn}/*"
    }
  ]
}
EOF
}