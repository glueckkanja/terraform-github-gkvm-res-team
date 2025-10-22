terraform {
  required_version = "~> 1.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.6"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
  }
}

provider "github" {
}

provider "modtm" {
  enabled = false
}

module "team" {
  source = "../../modules/team"

  name        = "example-team"
  description = "An example GitHub team"
  privacy     = "closed"
}
