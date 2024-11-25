locals {
  perm_map = {
    "pull"     = "r"
    "push"     = "rw"
    "maintain" = "maintainer"
  }
}

data "github_organization" "this" {
  name = var.github_organization
}

module "group" {
  source = "./modules/terraform-azuread-ea-group"

  team_name                   = var.team_name
  project_name                = var.project_name
  team_type                   = local.perm_map[var.permission]
  team_owners                 = var.team_owners
  group_description           = var.group_description
  enterprise_application_name = var.enterprise_application_name
  administrative_unit_name    = var.administrative_unit_name
}

module "repo" {
  source = "./modules/terraform-github-team-repo"

  group_name          = module.group.name
  team_name           = var.team_name
  project_name        = var.project_name
  permission          = var.permission
  group_description   = var.group_description
  github_organization = var.github_organization
}
