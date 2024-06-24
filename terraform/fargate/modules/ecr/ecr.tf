variable "ecr_repository" {
  type = string
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr_repository
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
