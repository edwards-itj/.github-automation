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
