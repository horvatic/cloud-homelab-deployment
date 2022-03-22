resource "aws_ecs_cluster" "cluster" {
  name               = "${CLUSTER_NAME}"
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = "100"
  }
}
