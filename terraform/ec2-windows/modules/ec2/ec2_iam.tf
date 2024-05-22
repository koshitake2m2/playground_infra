data "aws_iam_policy" "ssm_managerd_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "session_manager" {
  name = "session-manager-instance-profile"
  role = aws_iam_role.session_manager.name
}

resource "aws_iam_role" "session_manager" {
  name                = "session-manager-role"
  managed_policy_arns = [aws_iam_policy.session_manager.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy" "session_manager" {
  name   = "session-manager-policy"
  policy = data.aws_iam_policy.ssm_managerd_instance_core.policy
}

