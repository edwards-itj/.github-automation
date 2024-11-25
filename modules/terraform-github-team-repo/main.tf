resource "github_team" "this" {
  name        = var.group_name
  description = var.group_description
  privacy     = "closed"
}

data "github_external_groups" "test" {}

locals {
  test_groups = [
    for v in data.github_external_groups.test.external_groups : v
    if v.group_name == github_team.this.name
  ]
}

# It may take up to 40 minutes for the group to sync to GitHub
resource "time_sleep" "wait_20_minutes" {
  count = local.test_groups == [] ? 1 : 0

  create_duration = "20m"
}

data "github_external_groups" "this" {
  depends_on = [time_sleep.wait_20_minutes]
}

locals {
  groups = { for v in data.github_external_groups.this.external_groups : v.group_name => v }
}

resource "github_emu_group_mapping" "this" {
  team_slug = github_team.this.slug
  group_id  = local.groups[var.group_name].group_id
}

locals {
  name_parts       = split("-", github_team.this.name)
  contains_project = length(local.name_parts) > 6 || var.project_name != null
  team_name    = var.team_name == null ? element(local.name_parts, 4) : var.team_name
  project_name = local.contains_project == true ? (var.project_name != null ? var.project_name : element(local.name_parts, 5)) : ""
  repo_name    = join(".", compact([var.repo_prefix, local.team_name, local.project_name]))
}

#trivy:ignore:avd-git-0003
resource "github_repository" "this" {
  name       = local.repo_name
  visibility = "internal"
  auto_init  = true
}

resource "github_branch_default" "default" {
  repository = github_repository.this.name
  branch     = "main"
}

locals {
  perm_map = {
    "maintainer" = "maintain"
    "rw"         = "push"
    "r"          = "pull"
  }
  permission_from_group = element(local.name_parts, length(local.name_parts) - 1)
  permission            = var.permission == null ? local.perm_map[local.permission_from_group] : var.permission
}

resource "github_team_repository" "this" {
  team_id    = github_team.this.id
  repository = github_repository.this.name
  permission = local.permission
}

resource "github_repository_file" "codeowners" {
  repository          = github_repository.this.name
  autocreate_branch   = true
  branch              = "main"
  file                = ".github/CODEOWNERS"
  content             = <<EOH
  # This is a comment.
  # Each line is a file pattern followed by one or more owners.

  # These owners will be the default owners for everything in
  # the repo. Unless a later match takes precedence,
  # @global-owner1 and @global-owner2 will be requested for
  # review when someone opens a pull request.
  *       @${var.github_organization}/${github_team.this.name}
  EOH
  commit_message      = "Code Owners"
  commit_author       = "Setup User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}
