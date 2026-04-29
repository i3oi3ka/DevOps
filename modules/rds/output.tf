output "db_host" {
  description = "PostgreSQL host endpoint without port."
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : aws_db_instance.standard[0].address
}

output "db_port" {
  description = "PostgreSQL port."
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].port : aws_db_instance.standard[0].port
}

output "db_endpoint" {
  description = "PostgreSQL endpoint with port."
  value       = var.use_aurora ? "${aws_rds_cluster.aurora[0].endpoint}:${aws_rds_cluster.aurora[0].port}" : aws_db_instance.standard[0].endpoint
}
