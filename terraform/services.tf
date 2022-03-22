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
