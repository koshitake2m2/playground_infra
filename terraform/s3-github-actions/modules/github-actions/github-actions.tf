variable "aws_account_id" {
  type = string
}
variable "repo_owner" {
  type = string
}
variable "repo_name" {
  type = string
}
variable "bucket_arn" {
  type = string
}

// ref: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
resource "aws_iam_role" "github_acitons_role" {
  name                = "github-actions-role"
  managed_policy_arns = [aws_iam_policy.github_actions_policy.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated : "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        "Condition" : {
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:${var.repo_owner}/${var.repo_name}:*"
          },
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "github_actions_policy" {
  name = "github-actions-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${var.bucket_arn}/",
          "${var.bucket_arn}/*",
        ]
      }
    ]
  })
}
