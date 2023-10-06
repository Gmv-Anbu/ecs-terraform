module "backend" {
  source               = "git::https://github.com/lgallard/terraform-aws-ecr.git?ref=0.3.2"
  name                 = "backend-user"
  scan_on_push         = true
  image_tag_mutability = "MUTABLE"

}
