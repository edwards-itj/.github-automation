variable "administrative_unit_name" {
  type        = string
  description = "(Required) Name of the Administrative unit for GitHub groups in Entra Id."
}
variable "enterprise_application_name" {
  type        = string
  description = "(Required) Name of the Entra Id enterprise application for SCIM provisioning."
  default     = "GitHub Enterprise Managed User"
}

variable "github_organization" {
  type        = string
  description = "(Required) The GitHub organization name."
}

variable "team_name" {
  type        = string
  description = "(Required) Name of the team."
}

variable "group_description" {
  type        = string
  description = "(Optional) Description of the group."
  default     = ""
}

variable "group_prefix" {
  type        = string
  description = "(Optional) Prefix for the group."
  default     = ""
}

variable "project_name" {
  type        = string
  description = "(Optional) Name of the project."
  default     = null
  nullable    = true
}

variable "member_type" {
  type        = string
  description = "(Optional) Restricted User should be set here for organizational specific permissions. User role will grant permission to all internal repositories instead of scoped to just one with Restricted User."
  default     = "Restricted User"
  validation {
    condition     = contains(["Restricted User", "User"], var.member_type)
    error_message = "`member_type` must either be `Restricted User` or `User`"
  }
}

variable "members" {
  type        = list(string)
  description = "(Optional) List of member email addresses."
  default     = []
}

variable "team_owners" {
  type        = list(string)
  description = "(Optional) List of team owners."
  default     = null
}

variable "permission" {
  type        = string
  description = "(Optional) Permission level for the team on the repository."
  default     = "maintain"
  nullable    = true
  validation {
    condition = anytrue([
      var.permission == null,
      try(contains(["pull", "push", "maintain"], var.permission), false)
    ])
    error_message = "Must be one of pull, triage, push, maintain, admin"
  }
}
