module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.3.3"

  name                          = "${var.project_name}-${var.env_name}"
  force_destroy                 = true
  create_iam_user_login_profile = false
}

data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    sid    = "AppUserPermissions"
    effect = "Allow"

    actions = [
      "ecr:*",
      "ecs:*",
      "s3:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "iam_policy" {
  name        = "iam_policy"
  description = "Policy that allows service access"
  policy      = data.aws_iam_policy_document.iam_policy_document.json
}

resource "aws_iam_user_policy_attachment" "iam_user_policy_attachment" {
  user       = module.iam_user.iam_user_name
  policy_arn = aws_iam_policy.iam_policy.arn
}
