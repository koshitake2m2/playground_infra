variable "aws_account_id" {
  type = string
}
variable "repo_owner" {
  type = string
}
variable "repo_name" {
  type = string
}
variable "thumbprint" {
  type = string
}
variable "ecr_repository_name" {
  type = string
}
variable "ecs_task_execution_role_arn" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "service_name" {
  type = string
}
locals {
  region             = "ap-northeast-1"
  ecr_repository_arn = "arn:aws:ecr:${local.region}:${var.aws_account_id}:repository/${var.ecr_repository_name}"
  service_arn        = "arn:aws:ecs:${local.region}:${var.aws_account_id}:service/${var.cluster_name}/${var.service_name}"
}

// ref: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
resource "aws_iam_role" "github_acitons_role" {
  name = "github-actions-role"
  managed_policy_arns = [
    aws_iam_policy.github_actions_ecr_policy.arn,
    aws_iam_policy.github_actions_ecs_policy.arn,
  ]
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

// permissions requriements
// https://github.com/aws-actions/amazon-ecr-login#permissions
resource "aws_iam_policy" "github_actions_ecr_policy" {
  name = "github-actions-ecr-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "GetAuthorizationToken",
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowPushPull",
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ],
        "Resource" : local.ecr_repository_arn,
      }
    ]
  })
}

// permissions requriements
// https://github.com/aws-actions/amazon-ecs-deploy-task-definition#permissions
resource "aws_iam_policy" "github_actions_ecs_policy" {
  name = "github-actions-ecs-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "RegisterTaskDefinition",
        "Effect" : "Allow",
        "Action" : [
          "ecs:RegisterTaskDefinition",
          "ecs:DescribeTaskDefinition",
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "PassRolesInTaskDefinition",
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole"
        ],
        "Resource" : [
          # task_definition_task_roleとtask_definition_task_execution_roleが同じ
          var.ecs_task_execution_role_arn,
        ]
      },
      {
        "Sid" : "DeployService",
        "Effect" : "Allow",
        "Action" : [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ],
        "Resource" : [
          local.service_arn,
        ]
      }
    ]
  })
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider
resource "aws_iam_openid_connect_provider" "oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.thumbprint]
}
