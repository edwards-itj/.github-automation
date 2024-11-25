variable "enterprise_application_name" {
  type        = string
  description = "(Requred) Name of the enterprise application."
}

variable "administrative_unit_name" {
  type        = string
  description = "(Required) The administrative unit to create the groups in. This allows the service principal to not have Group Administrator on all groups in Entra Id."
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
  description = "(Optional) Prefix for the group name."
  default     = ""
}

variable "member_type" {
  type        = string
  description = "(Optional) Type of member. Must be 'Restricted User' or 'User'. Restricted User should be set here for repository specific permissions. User role will grant permission to all repositories instead of scoped to just one."
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

variable "project_name" {
  type        = string
  description = "(Optional) Name of the project."
  default     = null
  nullable    = true
}

variable "team_owners" {
  type        = list(string)
  description = "(Optional) List of team owners."
  default     = null
  nullable    = true
}

variable "team_type" {
  type        = string
  description = "(Optional) Type of the team. Must be 'maintainer', 'rw' (Read-Write), or 'r' (Read)."
  default     = "maintainer"
  validation {
    condition     = contains(["maintainer", "rw", "r"], var.team_type)
    error_message = "`team_type` must be 'maintainer', 'rw' (Read-Write), or 'r' (Read)"
  }
}
