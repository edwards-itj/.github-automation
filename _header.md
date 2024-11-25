# GitHub Repo and Team Setup with Enterprise Managed Users

## Description
This Terraform module is designed for GitHub Enterprise Managed Users to automate the creation and management of resources in Entra ID and GitHub. It performs the following tasks:

1. Creates a group in Entra ID.
2. Assigns the group to the SCIM enterprise application for provisioning to GitHub.
3. Creates a team in GitHub and syncs the Entra ID group to the team.
4. Creates a new repository for the team, setting up all the default configurations.

This automation addresses the lack of a native solution for granting a group of users the ability to create repositories without giving them organizational control. It also enables self-service repository creation by users while enforcing best practices and controls.

## Assumptions
1. You are using GitHub Enterprise Manged Users.
2. You are using Entra Id for SAML and SCIM.
3. You have already setup SSO and User/Group provisioning with and Entra Id Enterpise Application.
4. You have repository creation disabled in your GitHub Organization. (Pretty much the point of this repository)
5. You are using Entra Id with a P2 license. Future enhancements could allow for this to be optional.

## Setup/Prerequisites
In addition to the assumptions above. The below need to be setup prior to the use of this module.
1. Create and Entra Id Administrative Unit for GitHub Groups.

2. Create an Entra Id service principal (preferrably with OIDC).
<br>
[https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure)

3. Provide the Entra Id role `Directory Reader`

4. Provide Groups Administrator to the service principal on the Administrative Unit.

5. Provide the Entra Id role `Cloud Application Administrator` on the Enterprise Application and corresponding Application Registristration in Entra Id. (You should assign it to both).

6. Create a GitHub Application and key for repository creation.
 - Repository Permissions
   - `contents: write` - Required to create and manage repository contents.
   - `metadata: read` - Required to read repository metadata.
   - `administration: write` - Required to manage repository settings, including creating repositories.

 - Organization Permissions
   - `members: read` - Required to read organization members.
   - `team: write` - Required to create and manage teams within the organization.
   - `administration: write` - Required to manage organization settings, including creating teams.

7. Add the service principal secrets and GitHub Application secrets to your actions secrets.

## Modules

### (`terraform-azuread-ea-group`) Group Creation in Entra Id for GitHub Enterprise Managed Users
This module was writted to create groups in Entra Id for GitHub Enterprise Managed Users in an Administrative Unit and assign it to an Enterprise Application setup for SCIM provisioning to GitHub Enterprise Managed Users.

1. Retrieves the current Azure AD client configuration.
2. Fetches the Azure AD Administrative Unit based on the provided display name.
3. Retrieves Azure AD users specified in the `team_owners` variable.
4. Creates a local variable `team_owners` containing the object IDs of the team owners.
5. Creates an Azure AD group with the following properties:
   - Associated with the specified Administrative Unit.
   - Display name constructed from the provided group prefix, team name, project name, and team type.
   - Owners include the current Azure AD client and the team owners.
   - Security enabled.
   - Description as specified in the `group_description` variable.
6. Retrieves Azure AD users specified in the `members` variable.
7. Adds the specified members to the created Azure AD group.
8. Retrieves the Azure AD application based on the provided display name.
9. Fetches the Azure AD service principal associated with the application.
10. Assigns an app role to the created Azure AD group based on the specified member type.

### (`terraform-github-team-repo`) GitHub Repo and Team Setup with Enterprise Managed Users
1. Creates a GitHub team with the specified name and description.
2. Retrieves external groups from GitHub and filters them based on the team name.
3. Waits for up to 20 minutes for the group to sync to GitHub if no matching groups are found.
4. Retrieves the external groups again after the wait period.
5. Maps the GitHub team to an external group using the EMU group mapping.
6. Constructs the repository name based on the team name and project name.
7. Creates a GitHub repository with the constructed name and sets its visibility to internal.
8. Sets the default branch of the repository to "main".
9. Determines the appropriate permission level for the team based on the team name or provided permission.
10. Grants the GitHub team the determined permission level on the repository.
11. Creates a CODEOWNERS file in the repository with the GitHub team as the default owner for all files.

## Example
```terraform
module "github_team_repository" {
  source = "../../"

  team_name                   = "test"
  team_owners                 = []
  project_name                = "API"
  group_description           = "Test App API"
  enterprise_application_name = "GitHub Enterprise Managed Users"
  github_organization         = "Demo Org"
}
```