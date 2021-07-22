output "host_project" {
  value = module.host_project.project_id
}

output "service_project" {
  value = module.service-project.project_id
}

output "subnets" {
  value = module.networking.subnets
}