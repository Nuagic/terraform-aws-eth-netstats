terraform {
  required_version = ">= 0.14"
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "main" {
  default = true
}

data "aws_subnet_ids" "main" {
  vpc_id = data.aws_vpc.main.id
}


module "eth-netstats" {
  source                    = "Nuagic/eth-netstats/aws"
  name                      = "eth-netstats"
  vpc_id                    = data.aws_vpc.main.id
  subnet_ids                = data.aws_subnet_ids.main.ids
  service_discovery_service = aws_service_discovery_service.eth-netstats.id
  service_hostname          = "${aws_service_discovery_service.eth-netstats.name}.${aws_service_discovery_private_dns_namespace.my-network.name}"
  nodes = {
    node-1 = {
      host = "ip-10-100-9-51.eu-west-1.compute.internal"
      port = 8545
    }
  }
}

resource "aws_security_group_rule" "eth-netstats" {
  security_group_id = module.eth-netstats.service_sg_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_service_discovery_service" "eth-netstats" {
  name = "eth-netstats"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.my-network.id
    dns_records {
      ttl  = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }
}

resource "aws_service_discovery_private_dns_namespace" "my-network" {
  name        = "mynetwork.local"
  description = "My Private Network"
  vpc         = data.aws_vpc.main.id
}
