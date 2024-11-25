data "github_app" "this" {
  slug = var.github_app_name
}

data "github_repository_environments" "this" {
  repository = var.github_repository
}

locals {
  environment = { for v in data.github_repository_environments.this.environments : v.name => v }[var.github_environment]
}

# Create the environment secrets for the service principal
resource "github_actions_environment_secret" "app_id" {
  repository      = data.github_repository_environment.this.repository
  environment     = local.environment
  secret_name     = "GITHUB_APP_ID"
  plaintext_value = data.github_app.this.app_id
}

resource "github_actions_environment_secret" "installation_id" {
  repository      = data.github_repository_environment.this.repository
  environment     = local.environment
  secret_name     = "GITHUB_APP_INSTALLATION_ID"
  plaintext_value = data.github_app.this.installation_id
}

# resource "github_actions_environment_secret" "pem" {
#   repository      = data.github_repository_environment.this.repository
#   environment     = local.environment
#   secret_name     = "GITHUB_APP_PEM"
#   plaintext_value = data.github_app.this.pem
# }
