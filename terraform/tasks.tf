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

resource "aws_ecs_task_definition" "zracni-udar-service-task" {
  family = "udar"
  requires_compatibilities = [
    "FARGATE",
  ]
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 512
  execution_role_arn = "${AWS_SECRET_ROLE}"
  container_definitions = jsonencode([
    {
      name      = "zracni-udar-service"
      image     = "horvatic/zracni-udar-service:c62359b",
      secrets = [
        {
          name: "MONGO_CONNECTION_STRING"
          valueFrom: "${AWS_SSM_ARN}/MONGO_CONNECTION_STRING"
        },
        {
          name: "MONGO_DATABASE"
          valueFrom: "${AWS_SSM_ARN}/MONGO_DATABASE"
        },
        {
          name: "MONGO_COLLECTION"
          valueFrom: "${AWS_SSM_ARN}/MONGO_COLLECTION"
        },
        {
          name: "FRONT_END_HOST"
          valueFrom: "${AWS_SSM_ARN}/FRONT_END_HOST"
        },
        {
          name: "GITHUB_PAT"
          valueFrom: "${AWS_SSM_ARN}/GITHUB_PAT"
        },
      ]
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}
