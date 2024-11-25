<!-- BEGIN_TF_DOCS -->
# Group Creation in Entra Id for GitHub Enterprise Managed Users
This module was writted to create groups in Entra Id for GitHub Enterprise Managed Users in an Administrative Unit and assign it to an Enterprise Application setup for SCIM provisioning to GitHub Enterprise Managed Users.

## This Terraform configuration performs the following tasks:
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

<!-- markdownlint-disable MD033 -->
## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread)

## Resources

The following resources are used by this module:

- [azuread_app_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) (resource)
- [azuread_group.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) (resource)
- [azuread_group_member.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_member) (resource)
- [azuread_administrative_unit.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/administrative_unit) (data source)
- [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) (data source)
- [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) (data source)
- [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_user.members](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.team_owners](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_administrative_unit_name"></a> [administrative\_unit\_name](#input\_administrative\_unit\_name)

Description: (Required) The administrative unit to create the groups in. This allows the service principal to not have Group Administrator on all groups in Entra Id.

Type: `string`

### <a name="input_enterprise_application_name"></a> [enterprise\_application\_name](#input\_enterprise\_application\_name)

Description: (Requred) Name of the enterprise application.

Type: `string`

### <a name="input_team_name"></a> [team\_name](#input\_team\_name)

Description: (Required) Name of the team.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_group_description"></a> [group\_description](#input\_group\_description)

Description: (Optional) Description of the group.

Type: `string`

Default: `""`

### <a name="input_group_prefix"></a> [group\_prefix](#input\_group\_prefix)

Description: (Optional) Prefix for the group name.

Type: `string`

Default: `""`

### <a name="input_member_type"></a> [member\_type](#input\_member\_type)

Description: (Optional) Type of member. Must be 'Restricted User' or 'User'. Restricted User should be set here for repository specific permissions. User role will grant permission to all repositories instead of scoped to just one.

Type: `string`

Default: `"Restricted User"`

### <a name="input_members"></a> [members](#input\_members)

Description: (Optional) List of member email addresses.

Type: `list(string)`

Default: `[]`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: (Optional) Name of the project.

Type: `string`

Default: `null`

### <a name="input_team_owners"></a> [team\_owners](#input\_team\_owners)

Description: (Optional) List of team owners.

Type: `list(string)`

Default: `null`

### <a name="input_team_type"></a> [team\_type](#input\_team\_type)

Description: (Optional) Type of the team. Must be 'maintainer', 'rw' (Read-Write), or 'r' (Read).

Type: `string`

Default: `"maintainer"`

## Outputs

The following outputs are exported:

### <a name="output_app_name"></a> [app\_name](#output\_app\_name)

Description: The display name of the Entra Id application.

### <a name="output_app_registration_id"></a> [app\_registration\_id](#output\_app\_registration\_id)

Description: The ID of the Entra Id application registration.

### <a name="output_app_role"></a> [app\_role](#output\_app\_role)

Description: The role assigned to the application within the Entra Id group.

### <a name="output_enterprise_app_id"></a> [enterprise\_app\_id](#output\_enterprise\_app\_id)

Description: The ID of the Entra Id enterprise application service principal.

### <a name="output_members"></a> [members](#output\_members)

Description: A list of user principal names for the members of the Entra Id group.

### <a name="output_name"></a> [name](#output\_name)

Description: The display name of the Entra Id group.

### <a name="output_object_id"></a> [object\_id](#output\_object\_id)

Description: The unique object ID of the Entra Id group.

### <a name="output_owners"></a> [owners](#output\_owners)

Description: A list of user principal names for the owners of the Entra Id group, including the current client.

### <a name="output_project_name"></a> [project\_name](#output\_project\_name)

Description: The name of the project associated with this configuration.

## Modules

No modules.

  
<!-- END_TF_DOCS -->    