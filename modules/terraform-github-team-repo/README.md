<!-- BEGIN_TF_DOCS -->
# GitHub Repo and Team Setup with Enterprise Managed Users

## This Terraform configuration performs the following tasks:
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

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_github"></a> [github](#requirement\_github) (~> 6.0)

## Providers

The following providers are used by this module:

- <a name="provider_github"></a> [github](#provider\_github) (~> 6.0)

- <a name="provider_time"></a> [time](#provider\_time)

## Resources

The following resources are used by this module:

- [github_branch_default.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) (resource)
- [github_emu_group_mapping.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/emu_group_mapping) (resource)
- [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) (resource)
- [github_repository_file.codeowners](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) (resource)
- [github_team.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team) (resource)
- [github_team_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) (resource)
- [time_sleep.wait_20_minutes](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [github_external_groups.test](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/external_groups) (data source)
- [github_external_groups.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/external_groups) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization)

Description: (Required) The GitHub organization name.

Type: `string`

### <a name="input_group_name"></a> [group\_name](#input\_group\_name)

Description: (Required) The name of the group.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_group_description"></a> [group\_description](#input\_group\_description)

Description: (Optional) A description for the group.

Type: `string`

Default: `""`

### <a name="input_permission"></a> [permission](#input\_permission)

Description: (Optional) The permission level for the team on the repository. Must be one of pull, triage, push, maintain, admin.

Type: `string`

Default: `null`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: (Optional) The name of the project.

Type: `string`

Default: `null`

### <a name="input_repo_prefix"></a> [repo\_prefix](#input\_repo\_prefix)

Description: (Optional) A prefix to be added to the repository name.

Type: `string`

Default: `""`

### <a name="input_team_name"></a> [team\_name](#input\_team\_name)

Description: (Optional) The name of the team.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_group_id"></a> [group\_id](#output\_group\_id)

Description: The ID of the group associated with the project.

### <a name="output_group_name"></a> [group\_name](#output\_group\_name)

Description: The name of the group associated with the project.

### <a name="output_http_clone_url"></a> [http\_clone\_url](#output\_http\_clone\_url)

Description: The HTTP URL to clone the GitHub repository.

### <a name="output_name"></a> [name](#output\_name)

Description: The name of the GitHub repository.

### <a name="output_project_name"></a> [project\_name](#output\_project\_name)

Description: The name of the project.

### <a name="output_team_name"></a> [team\_name](#output\_team\_name)

Description: The name of the GitHub team associated with the repository.

## Modules

No modules.

  
<!-- END_TF_DOCS -->    