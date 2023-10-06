variable "region" {
  description = "Region where resources are deployed"
  default     = "ap-southeast-1"
}

variable "env_name" {
  description = "environment name"
  default     = "prod"
}

variable "project_name" {
  description = "environment name"
  default     = "staynex"
}

variable "key_pair_name" {
  description = "SSH key pair name"
  default     = "staynex-prod"
}

# ECS
variable "backend_user_ecr_uri" {
  description = "SSH key pair name"
  default     = "986496794269.dkr.ecr.ap-southeast-1.amazonaws.com/backend-user:latest"
}