# Unit tests: mock provider, no token, plan only. Assertions target configured
# values, never computed ones.
mock_provider "github" {}

variables {
  name = "unit-team"
}

run "defaults" {
  command = plan

  assert {
    condition     = github_team.this.name == "unit-team" && github_team.this.privacy == "secret"
    error_message = "name must follow var.name and privacy must default to secret"
  }

  assert {
    condition     = length(github_team_members.this) == 0
    error_message = "no membership resource without members or maintainers"
  }

  assert {
    condition     = length(output.repository_permissions) == 0
    error_message = "no repository grants without repository_permissions"
  }
}

run "members_and_maintainers_share_one_membership_resource" {
  command = plan

  variables {
    members     = ["alice", "carol"]
    maintainers = ["bob"]
  }

  assert {
    condition     = length(github_team_members.this) == 1
    error_message = "exactly one github_team_members resource when anyone is listed"
  }

  assert {
    condition     = length(github_team_members.this[0].members) == 3
    error_message = "every member and maintainer must be listed"
  }

  assert {
    condition     = anytrue([for m in github_team_members.this[0].members : m.username == "bob" && m.role == "maintainer"])
    error_message = "maintainers must get the maintainer role"
  }

  assert {
    condition     = alltrue([for m in github_team_members.this[0].members : m.role == "member" if m.username != "bob"])
    error_message = "members must get the member role"
  }
}

run "repository_grants_are_keyed_by_repository" {
  command = plan

  variables {
    repository_permissions = [
      { repository = "repo-a", permission = "push" },
      { repository = "repo-b", permission = "admin" },
    ]
  }

  assert {
    condition     = toset(keys(github_team_repository.this)) == toset(["repo-a", "repo-b"])
    error_message = "grants must be keyed by repository name; this key is a state address"
  }

  assert {
    condition     = github_team_repository.this["repo-b"].permission == "admin" && github_team_repository.this["repo-a"].permission == "push"
    error_message = "permission must be passed through per repository"
  }

  assert {
    condition     = toset(keys(output.repository_permissions)) == toset(["repo-a", "repo-b"])
    error_message = "output.repository_permissions must mirror the grants"
  }
}

run "closed_privacy_and_description" {
  command = plan

  variables {
    privacy     = "closed"
    description = "Platform team"
  }

  assert {
    condition     = github_team.this.privacy == "closed" && github_team.this.description == "Platform team"
    error_message = "privacy and description must be passed through"
  }
}

run "rejects_short_name" {
  command = plan

  variables {
    name = "a"
  }

  expect_failures = [var.name]
}

run "rejects_unknown_privacy" {
  command = plan

  variables {
    privacy = "open"
  }

  expect_failures = [var.privacy]
}

run "members_require_a_maintainer" {
  command = plan

  variables {
    members     = ["alice"]
    maintainers = []
  }

  expect_failures = [var.maintainers]
}
