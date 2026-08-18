terraform {
  required_version = "~> 1.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
  }
}

provider "github" {}

module "team" {
  source = "../../"

  name        = "example-team"
  description = "An example GitHub team"
  privacy     = "closed"
}
