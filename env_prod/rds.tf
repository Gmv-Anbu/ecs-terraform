# KMS Key required

data "sops_file" "secret_psql" {
  source_file = "secrets/secrets.enc.yaml"
  input_type  = "yaml"
}

module "rds_aurora_psql" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 6.1"

  name                                = "${var.project_name}-${var.env_name}"
  database_name                       = "${var.project_name}_${var.env_name}"
  engine                              = "aurora-postgresql"
  engine_version                      = "14.8"
  engine_mode                         = "provisioned"
  iam_database_authentication_enabled = false
  create_monitoring_role              = false
  performance_insights_enabled        = true
  skip_final_snapshot                 = false
  port                                = 5432
  auto_minor_version_upgrade          = false
  copy_tags_to_snapshot               = true
  master_username                     = yamldecode(data.sops_file.secret_psql.raw)["db"]["rds_user"]
  master_password                     = yamldecode(data.sops_file.secret_psql.raw)["db"]["password"]
  create_random_password              = false
  autoscaling_enabled                 = true
  autoscaling_min_capacity            = 1
  autoscaling_max_capacity            = 3
  vpc_id                              = module.vpc.vpc_id
  subnets                             = [aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id]
  allowed_security_groups             = [aws_security_group.task.id, aws_security_group.bastion.id]
  instance_class                      = "db.t3.medium"
  storage_encrypted                   = true
  apply_immediately                   = true
  db_parameter_group_name             = aws_db_parameter_group.psql_db_parameter_group.name
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.rds_cluster_parameter_group.name
  # db_cluster_db_instance_parameter_group_name = aws_db_parameter_group.psql_db_parameter_group.name
  deletion_protection            = true
  enable_global_write_forwarding = false
  backup_retention_period        = 7

  instances = {
    1 = {
      identifier          = "${var.project_name}-${var.env_name}"
      instance_class      = "db.t3.medium"
      publicly_accessible = false
    }
  }

  depends_on = [aws_db_parameter_group.psql_db_parameter_group]
}

resource "aws_db_parameter_group" "psql_db_parameter_group" {
  name   = "${var.project_name}-${var.env_name}"
  family = "aurora-postgresql14"

  # parameter {
  #   name  = "log_connections"
  #   value = "1"
  # }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group" {
  name        = "${var.project_name}-${var.env_name}"
  family      = "aurora-postgresql14"
  description = "RDS default cluster parameter group"

  # parameter {
  #   name  = "character_set_server"
  #   value = "utf8"
  # }

  # parameter {
  #   name  = "character_set_client"
  #   value = "utf8"
  # }
}