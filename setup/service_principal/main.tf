data "azuread_client_config" "current" {}

# Get the SCIM application and service principal
data "azuread_application" "scim" {
  display_name = var.scim_enterprise_app_name
}

data "azuread_service_principal" "scim" {
  display_name = var.scim_enterprise_app_name
}

# Create a new Azure AD application for the service principal to assign to github actions
resource "azuread_application_registration" "this" {
  display_name = var.service_principal_name
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application_registration.this.client_id
}

# Create a new federated identity credential for the service principal
resource "azuread_application_federated_identity_credential" "oidc_credential" {
  application_id = azuread_application_registration.this.id
  display_name   = "GitHub-OIDC"
  description    = "OIDC federated credential for GitHub Actions"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_organization}/${var.github_repository}:environment:${var.github_environment}"
  audiences      = ["api://AzureADTokenExchange"]
}

# Create a new Entra ID Administrative Unit
resource "azuread_administrative_unit" "this" {
  display_name = var.admin_unit_name
}

# Get the Directory Readers role
resource "azuread_directory_role" "directory_readers" {
  display_name = "Directory Readers"
}

# Get the Groups Administrator role
resource "azuread_directory_role" "groups_administrator" {
  display_name = "Groups Administrator"
}

# Get the Cloud Application Administrator role
resource "azuread_directory_role" "cloud_application_administrator" {
  display_name = "Cloud Application Administrator"
}

# Assign the role to the SCIM application
resource "azuread_directory_role_assignment" "cloud_app_application_assignment" {
  role_id             = azuread_directory_role.cloud_application_administrator.template_id
  principal_object_id = azuread_service_principal.this.object_id
  directory_scope_id  = format("/%s", data.azuread_application.scim.object_id)
}

# Assign the role to the SCIM service principal
resource "azuread_directory_role_assignment" "cloud_app_service_principal_assignment" {
  role_id             = azuread_directory_role.cloud_application_administrator.template_id
  principal_object_id = azuread_service_principal.this.object_id
  directory_scope_id  = format("/%s", data.azuread_service_principal.scim.object_id)
}

# Assign Directory Readers role to the service principal at the tenant scope
resource "azuread_directory_role_assignment" "directory_readers_assignment" {
  role_id             = azuread_directory_role.directory_readers.template_id
  principal_object_id = azuread_service_principal.this.object_id
}

# Assign Groups Administrator role to the service principal within the administrative unit
resource "azuread_directory_role_assignment" "groups_administrator_assignment" {
  role_id             = azuread_directory_role.groups_administrator.template_id
  principal_object_id = azuread_service_principal.this.object_id
  directory_scope_id  = "/administrativeUnits/${azuread_administrative_unit.this.object_id}"
}

resource "github_repository_environment" "this" {
  environment         = var.github_environment
  repository          = var.github_repository
  prevent_self_review = true
}

# Create the environment secrets for the service principal
resource "github_actions_environment_secret" "azure_client_id" {
  repository      = var.github_repository
  environment     = github_repository_environment.this.environment
  secret_name     = "ARM_CLIENT_ID"
  plaintext_value = azuread_application_registration.this.client_id
}

resource "github_actions_environment_secret" "azure_tenant_id" {
  repository      = var.github_repository
  environment     = github_repository_environment.this.environment
  secret_name     = "ARM_TENANT_ID"
  plaintext_value = data.azuread_client_config.current.tenant_id
}


