
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "development" {
  count = var.environment == "development" ? 1 : 0
  name  = "development-cluster"
}

resource "aws_ecs_cluster" "production" {
  count = var.environment == "production" ? 1 : 0
  name  = "production-cluster"
}

resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-family"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "my-container",
      "image": "654654608593.dkr.ecr.eu-north-1.amazonaws.com/myapp:latest",
      "memory": 512,
      "cpu": 256,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ]
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
}

resource "aws_ecs_service" "my_service" {
  count            = var.environment == "production" || var.pr_id != "" ? 1 : 0
  name             = var.environment == "production" ? "my-service" : "my-service-pr-${var.pr_id}"
  cluster          = var.environment == "production" ? aws_ecs_cluster.production.id : aws_ecs_cluster.development.id
  task_definition  = aws_ecs_task_definition.my_task_definition.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "ecs_sg" {
  security_group_id = "sg-1234567890abcdef0"
}
