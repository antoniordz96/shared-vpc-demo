output "subnet_self_links" {
  value = module.vpc.subnets_self_links
}

output "subnets" {
  value = module.vpc.subnets
}