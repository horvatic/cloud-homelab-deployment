provider "aws" {
  region = "${REGION}"
}

data "aws_vpc" "main" {
  id = "${VPC_ID}"
}

data "aws_subnet" "subnet" {
  vpc_id            = data.aws_vpc.main.id
  availability_zone = "us-east-2a"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_network_interface" "network_interface" {
  subnet_id       = aws_subnet.subnet.id
  security_groups = ["${SECURITY_GROUP}"]
}

resource "aws_instance" "dev" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.large"
  associate_public_ip_address = true
  key_name                    = "${KEY_PAIR_NAME}"
  network_interface {
    network_interface_id   = aws_network_interface.network_interface.id
    device_index           = 0
    delete_on_termination = true
  }
  credit_specification {
    cpu_credits = "standard"
  }
  root_block_device {
    delete_on_termination = true
    volume_size           = 200
  }
}