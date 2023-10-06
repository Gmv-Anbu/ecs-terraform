# Role
module "ecs-execution-role" {
  source  = "aisamji/ecs-execution-role/aws"
  version = "1.0.0"
}

# SNS Email alert

# Create an SNS topic
resource "aws_sns_topic" "task_scaling_topic" {
  name = "ecs_task_scaling_topic" # Update with your desired topic name
}

# Create an IAM role for CloudWatch Events
resource "aws_iam_role" "cloudwatch_events_role" {
  name = "ecs_scaling_events_role" # Update with your desired role name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach the required IAM policy to the role
resource "aws_iam_role_policy_attachment" "cloudwatch_events_policy_attachment" {
  role       = aws_iam_role.cloudwatch_events_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess" # Update with a more restrictive policy if desired
}

# Create the CloudWatch Events rule
resource "aws_cloudwatch_event_rule" "task_scaling_rule" {
  name        = "ecs_task_scaling_rule" # Update with your desired rule name
  description = "Rule for ECS task scaling"

  event_pattern = <<EOF
{
  "source": [
    "aws.ecs"
  ],
  "detail-type": [
    "ECS Task State Change",
    "ECS Container Instance State Change"
  ],
  "detail": {
    "desiredStatus": [
      "RUNNING",
      "STOPPED"
    ]
  }
}
EOF
}

# Create a CloudWatch Events target for the SNS topic
resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.task_scaling_rule.name
  target_id = "sns_target"
  arn       = aws_sns_topic.task_scaling_topic.arn
}

# Create an SNS subscription for email notifications
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.task_scaling_topic.arn
  protocol  = "email"
  endpoint  = "devops-team@accubits.com" # Update with your desired email address
}
