output "app_name" {
  description = "The display name of the Entra Id application."
  value       = data.azuread_application.this.display_name
}

output "app_registration_id" {
  description = "The ID of the Entra Id application registration."
  value       = data.azuread_application.this.id
}

output "app_role" {
  description = "The role assigned to the application within the Entra Id group."
  value       = var.member_type
}

output "enterprise_app_id" {
  description = "The ID of the Entra Id enterprise application service principal."
  value       = data.azuread_service_principal.this.id
}

output "members" {
  description = "A list of user principal names for the members of the Entra Id group."
  value       = [for k, v in data.azuread_user.members : v.user_principal_name]
}

output "name" {
  description = "The display name of the Entra Id group."
  value       = azuread_group.this.display_name
}

output "object_id" {
  description = "The unique object ID of the Entra Id group."
  value       = azuread_group.this.object_id
}

output "owners" {
  description = "A list of user principal names for the owners of the Entra Id group, including the current client."
  value       = compact(concat([data.azuread_client_config.current.object_id], [for k, v in data.azuread_user.team_owners : v.user_principal_name]))
}

output "project_name" {
  description = "The name of the project associated with this configuration."
  value       = var.project_name
}