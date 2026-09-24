terraform {
  required_version = "~> 1.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "github" {}

# The end-to-end test creates this team for real and deletes it again, so the
# name has to be unique per run: a fixed name collides between concurrent runs,
# and a leftover from a cancelled run would block the next one. The gkvm-e2e-
# prefix makes any leftover recognisable.
resource "random_string" "suffix" {
  length  = 6
  lower   = true
  numeric = true
  special = false
  upper   = false
}

module "team" {
  source = "../../"

  name        = "gkvm-e2e-team-${random_string.suffix.result}"
  description = "An example GitHub team"
  privacy     = "closed"
}
