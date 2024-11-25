output "app_name" {
  description = "The name of the application that the repository is going to be used for."
  value       = module.group.app_name
}

output "app_registration_id" {
  description = "The ID of the application registration for SCIM provisioning in Entra ID."
  value       = module.group.app_registration_id
}

output "app_role" {
  description = "The Entra Id application role assigned to the group. This translates to the GitHub Org role and not the repository permission."
  value       = module.group.app_role
}

output "enterprise_app_id" {
  description = "The ID of the enterprise application in Entra Id."
  value       = module.group.enterprise_app_id
}

output "github_org_name" {
  description = "The name of the GitHub Enterprise organization."
  value       = data.github_organization.this.orgname
}

output "group_name" {
  description = "The name of the Entra Id group. This module also gives the same name to the GitHub Team."
  value       = module.repo.group_name
}

output "http_clone_url" {
  description = "The HTTP clone URL of the GitHub repository that was created for the team."
  value       = module.repo.http_clone_url
}

output "members" {
  description = "The members that were assigned to the group in Entra Id."
  value       = module.group.members
}

output "owners" {
  description = "The owners of the group in Entra Id. These users have the permission to add and remove members as needed."
  value       = module.group.owners
}

output "project_name" {
  description = "The name of the project. This is used as an optional identifier for multiple projects for the same application."
  value       = var.project_name
}

output "repo_name" {
  description = "The name of the GitHub repository."
  value       = module.repo.name
}

output "team_name" {
  description = "The name of the GitHub team. This modules uses the same name for the Entra Id group and GitHub Team."
  value       = module.repo.team_name
}