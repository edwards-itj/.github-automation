output "group_id" {
  description = "The ID of the group associated with the project."
  value       = local.groups[var.group_name].group_id
}

output "group_name" {
  description = "The name of the group associated with the project."
  value       = local.groups[var.group_name].group_name
}

output "http_clone_url" {
  description = "The HTTP URL to clone the GitHub repository."
  value       = github_repository.this.http_clone_url
}

output "name" {
  description = "The name of the GitHub repository."
  value       = github_repository.this.name
}

output "project_name" {
  description = "The name of the project."
  value       = var.project_name
}

output "team_name" {
  description = "The name of the GitHub team associated with the repository."
  value       = github_team.this.name
}