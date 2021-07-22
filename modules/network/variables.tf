variable "host_project_id" {
  type        = string
  description = "Host project ID."
}
variable "region" {
  type        = string
  description = "GCP Region to deploy network resources."
}

variable "network_name" {
  type        = string
  default     = "custom-network"
  description = "Network Name."
}