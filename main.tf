
resource "aws_ecs_cluster" "ethstats" {
  count = var.create_ecs_cluster ? 1 : 0
  name  = var.name
  tags  = var.tags
}

module "ethstats" {
  source                             = "telia-oss/ecs-fargate/aws"
  version                            = "5.2.0"
  name_prefix                        = var.name
  vpc_id                             = var.vpc_id
  private_subnet_ids                 = var.subnet_ids
  cluster_id                         = var.create_ecs_cluster ? aws_ecs_cluster.ethstats[0].id : var.ecs_cluster
  task_container_image               = var.ethstats_docker_image
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  task_definition_cpu                = var.cpu
  task_definition_memory             = var.memory
  desired_count                      = 1
  task_container_port                = var.ethstats_port
  health_check = {
    port = "traffic-port"
  }
  tags                              = var.tags
  service_registry_arn              = var.service_discovery_service
  with_service_discovery_srv_record = false
  task_container_environment = {
    PORT      = var.ethstats_port
    WS_SECRET = random_password.ethstats.result
  }
}

resource "random_password" "ethstats" {
  length  = 16
  special = false
}

module "nodes" {
  source  = "telia-oss/ecs-fargate/aws"
  version = "5.4.0"
  #source                             = "github.com/feraudet/terraform-aws-ecs-fargate?ref=ethstats"
  for_each                           = var.nodes
  name_prefix                        = each.key
  vpc_id                             = var.vpc_id
  private_subnet_ids                 = var.subnet_ids
  cluster_id                         = var.create_ecs_cluster ? aws_ecs_cluster.ethstats[0].id : var.ecs_cluster
  task_container_image               = var.eth-net-intelligence-api_docker_image
  aws_iam_role_execution_suffix      = "-exec"
  aws_iam_role_task_suffix           = "-task"
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  task_definition_cpu                = 1024
  task_definition_memory             = 2048
  desired_count                      = 1
  task_container_port                = var.ethstats_port
  health_check = {
    port = "traffic-port"
  }
  tags = var.tags
  task_container_environment = {
    NODE_ENV      = "production"
    RPC_HOST      = each.value["host"]
    RPC_PORT      = each.value["port"]
    INSTANCE_NAME = each.key
    WS_SERVER     = "ws://${var.service_hostname}:${var.ethstats_port}"
    WS_SECRET     = random_password.ethstats.result
    NO_HASHRATE   = lookup(each.value, "no_hashrate", false)
  }
}

