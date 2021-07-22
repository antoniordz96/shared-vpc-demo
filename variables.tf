variable "organization_id" {
  type        = string
  description = "GCP organization ID."
}

variable "billing_account_id" {
  type        = string
  description = "Billing Account to associate resources to."
}

variable "region" {
  type        = string
  description = "GCP Region to deploy resources."
  default     = "us-central1"
}