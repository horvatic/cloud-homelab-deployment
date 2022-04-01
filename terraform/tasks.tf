resource "aws_ecs_task_definition" "zracni-udar-ui-task" {
  family = "udarui"
  requires_compatibilities = [
    "FARGATE",
  ]
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 512
  container_definitions = jsonencode([
    {
      name      = "zracni-udar-ui"
      image     = "horvatic/zracni-udar-ui:1673e20"
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
      image     = "horvatic/zracni-udar-service:c3684ad",
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
        {
          name: "API_KEY"
          valueFrom: "${AWS_SSM_ARN}/API_KEY"
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
