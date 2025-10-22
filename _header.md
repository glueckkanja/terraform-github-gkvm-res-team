# terraform-github-gkvm-res-team

This repository contains Terraform modules for managing GitHub Teams.


Currently the module supports:

- Creating a new GitHub Team
- Managing team members
- Managing team maintainers

## Usage

To use this module in your Terraform configuration, you'll need to provide values for the required variables.

### Example - Basic Team Creation

```terraform
module "github_team" {
  source = "glueckkanja/terraform-github-gkvm-res-team"
  name   = "example-team"
  description = "An example GitHub team"
  privacy     = "closed"

  members = [
    "user1",
    "user2"
  ]
}
