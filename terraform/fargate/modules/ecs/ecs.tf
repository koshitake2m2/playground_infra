variable "app_api_image_uri" {
  type = string
}

variable "app_api_container_port" {
  type = number
}

variable "vpc_subnet_ids" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}
output "ecs_service_name" {
  value = aws_ecs_service.app_api_service.name
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers
resource "aws_ecs_cluster_capacity_providers" "ecs_cluster" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }
}


// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "app_api_task" {
  family                   = "app_api_task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024 # 1024 units = 1 vCPU
  memory                   = 2048 # 2 GB
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "app_api"
      image     = var.app_api_image_uri
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = var.app_api_container_port
          # awsvpc network mode requires hostPort to be the same as containerPort
          hostPort = var.app_api_container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app_api.name
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    },
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "app_api_service" {
  name            = "app_api_service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_api_task.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }

  network_configuration {
    subnets          = var.vpc_subnet_ids
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app_api"
    container_port   = var.app_api_container_port
  }

}
