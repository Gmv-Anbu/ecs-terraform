# User Backend
resource "aws_ecs_cluster" "cluster_user" {
  name = "backend-user"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.kms_key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.cloudwatch_log_group_user.name
      }
    }
  }
}

resource "aws_ecs_service" "service_user" {
  name            = "backend-user"
  cluster         = aws_ecs_cluster.cluster_user.id
  task_definition = aws_ecs_task_definition.task_definition_user.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.task.id]
    subnets         = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.id
    container_name   = "backend-user"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.lb_listener]
}



resource "aws_ecs_task_definition" "task_definition_user" {
  family                   = "backend-user"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = module.ecs-execution-role.ecs_role_arn

  container_definitions = <<DEFINITION
[
  {
    "image": "${var.backend_user_ecr_uri}",
    "cpu": 512,
    "memory": 1024,
    "name": "backend-user",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/backend-user",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
        }
      }    
  }
]
DEFINITION
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group_user" {
  name = "/ecs/backend-user"
}

# Autoscaling 
resource "aws_appautoscaling_target" "to_target_user" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster_user.name}/${aws_ecs_service.service_user.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "to_memory_user" {
  name               = "to-memory-user"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.to_target_user.resource_id
  scalable_dimension = aws_appautoscaling_target.to_target_user.scalable_dimension
  service_namespace  = aws_appautoscaling_target.to_target_user.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "to_cpu_user" {
  name               = "to-cpu-user"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.to_target_user.resource_id
  scalable_dimension = aws_appautoscaling_target.to_target_user.scalable_dimension
  service_namespace  = aws_appautoscaling_target.to_target_user.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}


resource "aws_cloudwatch_log_group" "cloudwatch_log_group_user_cron" {
  name = "/ecs/backend-user-cron"
}