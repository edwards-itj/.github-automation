variable "github_organization" {
  type        = string
  description = "(Required) The name of the GitHub organization."
}

variable "github_repository" {
  type        = string
  description = "(Required) The name of the repository to create the service principal secrets in."
}

variable "github_environment" {
  type        = string
  default     = "dev"
  description = "(Required) The name of the environment to create the service principal secrets in."
}

variable "admin_unit_name" {
  type        = string
  default     = "GitHub OIDC Administrative Unit"
  description = "(Required) The name of the administrative unit to create for the groups."
}

variable "scim_enterprise_app_name" {
  type        = string
  default     = "GitHub Enterprise Managed User"
  description = "(Required) The name of the SCIM/SSO enterprise application."
}

variable "service_principal_name" {
  type        = string
  default     = "github-oidc-app-prod"
  description = "(Required) The name of the service principal to create."
}
