module "github_team_repository" {
  source = "../../"

  team_name                   = "test"
  team_owners                 = []
  project_name                = "API"
  group_description           = "Test App API"
  enterprise_application_name = "GitHub Enterprise Managed Users"
  github_organization         = "Demo Org"
}
