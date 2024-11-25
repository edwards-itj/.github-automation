data "azuread_client_config" "current" {}

data "azuread_administrative_unit" "this" {
  display_name = var.administrative_unit_name
}

data "azuread_user" "team_owners" {
  for_each            = var.team_owners != null ? toset(var.team_owners) : toset([])
  user_principal_name = each.value
}

locals {
  team_owners = [for k, v in data.azuread_user.team_owners : v.object_id]
}

resource "azuread_group" "this" {
  administrative_unit_ids = [data.azuread_administrative_unit.this.id]
  display_name            = join("-", compact([var.group_prefix, var.team_name, var.project_name, var.team_type]))
  owners                  = compact(concat([data.azuread_client_config.current.object_id], local.team_owners))
  security_enabled        = true
  description             = var.group_description
}

data "azuread_user" "members" {
  for_each            = var.members != null ? toset(var.members) : toset([])
  user_principal_name = each.value
}

resource "azuread_group_member" "this" {
  for_each         = data.azuread_user.members
  group_object_id  = azuread_group.this.object_id
  member_object_id = each.value.object_id
}

data "azuread_application" "this" {
  display_name = var.enterprise_application_name
}

data "azuread_service_principal" "this" {
  client_id = data.azuread_application.this.client_id
}

resource "azuread_app_role_assignment" "this" {
  app_role_id         = { for v in data.azuread_application.this.app_roles : v.display_name => v }[var.member_type].id
  principal_object_id = azuread_group.this.object_id
  resource_object_id  = data.azuread_service_principal.this.object_id
}
