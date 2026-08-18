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

### Team membership

`members` and `maintainers` are combined into a single authoritative
`github_team_members` resource: anyone not listed is removed from the team.

Two rules follow from how GitHub behaves, and the module enforces the first:

- **A team with members must have at least one maintainer.** GitHub automatically
  promotes a member to maintainer when a team has none, which Terraform then tries
  to demote on the next plan, producing a diff that never converges. Passing
  `members` without `maintainers` is rejected at plan time.
- **Do not list an organisation owner under `members`.** GitHub grants owners the
  maintainer role regardless, causing the same perpetual diff. List them under
  `maintainers` instead.

Leaving both lists empty is supported: the module then creates the team but does
not manage its membership at all, and members added by other means are left alone.

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
