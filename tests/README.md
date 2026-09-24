# Tests

## `unit/`

`tofu test` suite with a mock `github` provider: no token, no network, plan only. It pins the module's contract:

- input validations reject what they should (`expect_failures`)
- members and maintainers land in one `github_team_members` resource with the right roles
- repository grants are keyed by repository name, which is a state address

Run it with `./gkvm test-unit`; it is part of `./gkvm pr-check` and of the `unit tests` CI job. Assertions only target configured values; computed attributes are unknown under `plan` with a mock provider.

## `integration/`

Not present yet. Would run `tofu test` against a sandbox organisation with real credentials (`GKVM_GITHUB_TOKEN`, `GKVM_GITHUB_OWNER` on the `test` environment).
