terraform {
  required_version = ">= 0.13"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "azuread" {
  # Configure Azure AD provider
}

provider "github" {
  owner = var.github_organization
}