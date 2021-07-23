output "host_project" {
  value       = module.host_project.project_id
  description = "Host Project ID."
}

output "service_project" {
  value       = module.service-project.project_id
  description = "Service Project ID."
}

output "subnets" {
  value       = module.networking.subnets
  description = "Subnets created in environment."
}

output "application_external_ip" {
  value       = module.http-lb.external_ip
  description = "HTTP Load Balancer external IP for reaching Apache Web Server."
}