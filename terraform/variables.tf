variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "resource_group_name" {
  description = "Resource group for the cloud security operations platform"
  type        = string
  default     = "rg-azure-cloud-security-operations"
}