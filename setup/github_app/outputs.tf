output "app_id" {
  value       = data.github_app.this.app_id
  description = "The ID of the GitHub App."
}

output "installation_id" {
  value       = data.github_app.this.installation_id
  description = "The ID of the GitHub App installation."
}

# output "pem" {
#   value = data.github_app.this.pem
# }