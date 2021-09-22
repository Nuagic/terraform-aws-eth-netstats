output "service_sg_id" {
  description = "The Amazon Resource Name (ARN) that identifies the service security group"
  value       = module.ethstats.service_sg_id
}

