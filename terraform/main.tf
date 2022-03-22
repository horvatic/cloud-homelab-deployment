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
