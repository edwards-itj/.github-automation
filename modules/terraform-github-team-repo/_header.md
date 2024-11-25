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
