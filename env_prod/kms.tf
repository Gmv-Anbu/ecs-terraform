# KMS Key required for ECS Cluster and Database
resource "aws_kms_key" "kms_key" {
  description             = "KMS Key"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.project_name}-${var.env_name}"
  target_key_id = aws_kms_key.kms_key.key_id
}