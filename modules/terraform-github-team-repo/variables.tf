variable "github_organization" {
  type        = string
  description = "(Required) The GitHub organization name."
}

variable "group_name" {
  type        = string
  description = "(Required) The name of the group."
}

variable "group_description" {
  type        = string
  description = "(Optional) A description for the group."
  default     = ""
}

variable "permission" {
  type        = string
  description = "(Optional) The permission level for the team on the repository. Must be one of pull, triage, push, maintain, admin."
  default     = null
  validation {
    condition = anytrue([
      var.permission == null,
      try(contains(["pull", "triage", "push", "maintain", "admin"], var.permission), false)
    ])
    error_message = "Must be one of pull, triage, push, maintain, admin"
  }
  nullable = true
}

variable "project_name" {
  type        = string
  description = "(Optional) The name of the project."
  default     = null
  nullable    = true
}

variable "repo_prefix" {
  type        = string
  description = "(Optional) A prefix to be added to the repository name."
  default     = ""
}

variable "team_name" {
  type        = string
  description = "(Optional) The name of the team."
  default     = null
  nullable    = true
}