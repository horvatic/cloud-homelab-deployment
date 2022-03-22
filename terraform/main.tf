provider "aws" {
  region = "${REGION}"
}

data "aws_vpc" "main" {
  id = "${VPC_ID}"
}

data "aws_subnet" "subnets" {
  for_each          = toset(["us-east-2a"])
  vpc_id            = data.aws_vpc.main.id
  availability_zone = each.value
}

resource "aws_ecs_cluster" "cluster" {
  name               = "${CLUSTER_NAME}"
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = "100"
  }
}

resource "aws_ecs_task_definition" "task" {
  family = "service"
  requires_compatibilities = [
    "FARGATE",
  ]
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 512
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:1.21.6"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name                  = "nginx"
  cluster               = aws_ecs_cluster.cluster.id
  task_definition       = aws_ecs_task_definition.task.arn
  wait_for_steady_state = true
  desired_count         = 1

  network_configuration {
    subnets          = [for s in data.aws_subnet.subnets : s.id]
    assign_public_ip = true
    security_groups = ["${SECURITY_GROUP}"]
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE"
    weight            = 100
  }
}