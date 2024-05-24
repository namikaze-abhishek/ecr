output "cluster_name" {
  value = var.environment == "production" ? aws_ecs_cluster.production.name : aws_ecs_cluster.development.name
}