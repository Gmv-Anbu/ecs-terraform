

# Backend
resource "aws_lb" "lb" {
  name            = "backend"
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.lb.id, aws_security_group.task.id, aws_security_group.bastion.id]
}

resource "aws_lb_target_group" "target_group" {
  name        = "target-group-user-backend"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.id
    type             = "forward"
  }
}
