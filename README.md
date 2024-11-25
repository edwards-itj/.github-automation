<!-- BEGIN_TF_DOCS -->
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

## Calling API
### With curl
```
#export OWNER=$(gh org list --limit 1)
export OWNER=$(gh repo view --json owner | jq -r '.owner.login')
export REPO=".github-automation"
export WORKFLOW_ID=$(gh workflow list --json name,id,path | jq '.[] | select(.name=="Setup Repository")' | jq '.id')

PATH="/repos/$OWNER/$REPO/actions/workflows/$WORKFLOW_ID/dispatches"
URI="https://api.github.com$PATH"

data='{
  "ref":"main",
  "inputs":{
    "group_description": "",
    "group_prefix": "",
    "administrative_unit_name": "GitHub",
    "team_name": "Team",
    "project_name": "Project",
    "permission": "maintain",
    "app_name": "GitHub Enterprise Managed User",
    "github_organization": "eitj-demo-org"
}}'

auth="Authorization: Bearer $(gh auth token)"

curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H $auth \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  $URI \
  -d $data
```
### With GH CLI
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  $PATH \
  -f "ref=main" \
  -f "inputs[group_description]=", \
  -f "inputs[group_prefix]=", \
  -f "inputs[administrative_unit_name]=GitHub", \
  -f "inputs[team_name]=Team", \
  -f "inputs[project_name]=Project", \
  -f "inputs[permission]=maintain", \
  -f "inputs[app_name]=GitHub Enterprise Managed User", \
  -f "inputs[github_organization]=OWNER"
```

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

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 3.0)

- <a name="requirement_github"></a> [github](#requirement\_github) (~> 6.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.12)

## Providers

The following providers are used by this module:

- <a name="provider_github"></a> [github](#provider\_github) (6.3.1)

## Resources

The following resources are used by this module:

- [github_organization.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/organization) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_administrative_unit_name"></a> [administrative\_unit\_name](#input\_administrative\_unit\_name)

Description: (Required) Name of the Administrative unit for GitHub groups in Entra Id.

Type: `string`

### <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization)

Description: (Required) The GitHub organization name.

Type: `string`

### <a name="input_team_name"></a> [team\_name](#input\_team\_name)

Description: (Required) Name of the team.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enterprise_application_name"></a> [enterprise\_application\_name](#input\_enterprise\_application\_name)

Description: (Required) Name of the Entra Id enterprise application for SCIM provisioning.

Type: `string`

Default: `"GitHub Enterprise Managed User"`

### <a name="input_group_description"></a> [group\_description](#input\_group\_description)

Description: (Optional) Description of the group.

Type: `string`

Default: `""`

### <a name="input_group_prefix"></a> [group\_prefix](#input\_group\_prefix)

Description: (Optional) Prefix for the group.

Type: `string`

Default: `""`

### <a name="input_member_type"></a> [member\_type](#input\_member\_type)

Description: (Optional) Restricted User should be set here for organizational specific permissions. User role will grant permission to all internal repositories instead of scoped to just one with Restricted User.

Type: `string`

Default: `"Restricted User"`

### <a name="input_members"></a> [members](#input\_members)

Description: (Optional) List of member email addresses.

Type: `list(string)`

Default: `[]`

### <a name="input_permission"></a> [permission](#input\_permission)

Description: (Optional) Permission level for the team on the repository.

Type: `string`

Default: `"maintain"`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: (Optional) Name of the project.

Type: `string`

Default: `null`

### <a name="input_team_owners"></a> [team\_owners](#input\_team\_owners)

Description: (Optional) List of team owners.

Type: `list(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_app_name"></a> [app\_name](#output\_app\_name)

Description: The name of the application that the repository is going to be used for.

### <a name="output_app_registration_id"></a> [app\_registration\_id](#output\_app\_registration\_id)

Description: The ID of the application registration for SCIM provisioning in Entra ID.

### <a name="output_app_role"></a> [app\_role](#output\_app\_role)

Description: The Entra Id application role assigned to the group. This translates to the GitHub Org role and not the repository permission.

### <a name="output_enterprise_app_id"></a> [enterprise\_app\_id](#output\_enterprise\_app\_id)

Description: The ID of the enterprise application in Entra Id.

### <a name="output_github_org_name"></a> [github\_org\_name](#output\_github\_org\_name)

Description: The name of the GitHub Enterprise organization.

### <a name="output_group_name"></a> [group\_name](#output\_group\_name)

Description: The name of the Entra Id group. This module also gives the same name to the GitHub Team.

### <a name="output_http_clone_url"></a> [http\_clone\_url](#output\_http\_clone\_url)

Description: The HTTP clone URL of the GitHub repository that was created for the team.

### <a name="output_members"></a> [members](#output\_members)

Description: The members that were assigned to the group in Entra Id.

### <a name="output_owners"></a> [owners](#output\_owners)

Description: The owners of the group in Entra Id. These users have the permission to add and remove members as needed.

### <a name="output_project_name"></a> [project\_name](#output\_project\_name)

Description: The name of the project. This is used as an optional identifier for multiple projects for the same application.

### <a name="output_repo_name"></a> [repo\_name](#output\_repo\_name)

Description: The name of the GitHub repository.

### <a name="output_team_name"></a> [team\_name](#output\_team\_name)

Description: The name of the GitHub team. This modules uses the same name for the Entra Id group and GitHub Team.

## Modules

The following Modules are called:

### <a name="module_group"></a> [group](#module\_group)

Source: ./modules/terraform-azuread-ea-group

Version:

### <a name="module_repo"></a> [repo](#module\_repo)

Source: ./modules/terraform-github-team-repo

Version:

  
<!-- END_TF_DOCS -->    