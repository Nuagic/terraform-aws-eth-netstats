variable "name" {
  description = "Resources name"
  type        = string
}

variable "tags" {
  description = "Resources tags"
  type        = map(string)
  default     = {}
}

variable "create_ecs_cluster" {
  description = "Create ECS cluster"
  type        = bool
  default     = true
}

variable "ecs_cluster" {
  description = "ECS cluster"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "ethstats_docker_image" {
  description = "EthStats docker image"
  type        = string
  default     = "nuagic/eth-netstats:latest"
}

variable "ethstats_port" {
  description = "EthStats port"
  type        = number
  default     = 80
}

variable "eth-net-intelligence-api_docker_image" {
  description = "eth-net-intelligence-api docker image"
  type        = string
  default     = "nuagic/eth-net-intelligence-api:latest"
}

variable "service_discovery_service" {
  description = "Service Discovery service id"
  type        = string
  default     = null
}

variable "service_hostname" {
  description = "Service Discovery service hostname"
  type        = string
  default     = null
}

variable "nodes" {
  description = "Node map"
  type        = map(object({ host = string, port = number }))
}

variable "cpu" {
  description = "CPU"
  type        = number
  default     = 1024
}

variable "memory" {
  description = "Memory"
  type        = number
  default     = 2048
}

