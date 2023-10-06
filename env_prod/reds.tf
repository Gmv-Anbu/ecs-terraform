module "redis" {
  source  = "umotif-public/elasticache-redis/aws"
  version = "~> 3.0.0"

  name_prefix        = var.project_name
  num_cache_clusters = 1
  node_type          = "cache.t3.small"

  engine_version             = "6.x"
  port                       = 6379
  maintenance_window         = "mon:03:00-mon:04:00"
  snapshot_window            = "04:00-06:00"
  snapshot_retention_limit   = 7
  multi_az_enabled           = false
  automatic_failover_enabled = true

  at_rest_encryption_enabled = true
  transit_encryption_enabled = false
  # auth_token = yamldecode(data.sops_file.secret.raw)["db"]["password"]

  apply_immediately = true
  family            = "redis6.x"
  description       = "elasticache redis."

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  parameter = [
    {
      name  = "repl-backlog-size"
      value = "16384"
    }
  ]
}