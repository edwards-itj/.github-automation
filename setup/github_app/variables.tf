variable "github_organization" {
  type        = string
  description = "(Required) The name of the GitHub organization."
}

variable "github_repository" {
  type        = string
  description = "(Required) The name of the repository to create the GitHub App secrets in."
}

variable "github_environment" {
  type        = string
  description = "(Required) The name of the environment to create the GitHub App secrets in."
}

variable "github_app_name" {
  type        = string
  description = "(Required) The slug of the GitHub App to create and get the secrets for."
}