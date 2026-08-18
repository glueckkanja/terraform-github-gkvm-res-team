# terraform-github-gkvm-res-team

This is a Terraform resource module to manage a GitHub team.

Currently the module supports:

- Creating a new GitHub team
- Managing team members and maintainers
- Granting the team access to repositories

## Usage

### Example - Basic team creation

```terraform
module "github_team" {
  source  = "glueckkanja/gkvm-res-team/github"
  version = "~> 2.0"

  name        = "example-team"
  description = "An example GitHub team"
  privacy     = "closed"

  members = [
    "user1",
    "user2",
  ]
}
```

### Example - Referencing the team from another module

The team ID is exported as `resource_id`. Terraform types every resource ID as a
string, so wrap it in `tonumber()` wherever a number is required — for example
when passing the team to the `environments[].reviewers.teams` argument of
`glueckkanja/gkvm-res-repository/github`, which is typed `set(number)`.

```terraform
environments = [
  {
    name = "production"
    reviewers = {
      teams = [tonumber(module.github_team.resource_id)]
    }
  },
]
```
