---
description: 'terraform-github-gkvm-res-team — a glueckkanja Verified Module (GKVM) for GitHub'
applyTo: '**/*.terraform, **/*.tf, **/*.tfvars, **/*.tfstate, **/*.tflint.hcl, **/*.tf.json, **/*.tfvars.json'
---

# terraform-github-gkvm-res-team

A **glueckkanja Verified Module (GKVM)** that manages GitHub teams, and nothing else.

| | |
|---|---|
| Registry address | `glueckkanja/gkvm-res-team/github` |
| Repository | `glueckkanja/terraform-github-gkvm-res-team` |
| Provider | `integrations/github` — the only one |
| Submodules | none |

This repository was originally generated from the Azure Verified Modules (AVM) template, but it is **not an AVM module** and is not governed by AVM rules or tooling. Treat any leftover AVM convention you encounter as an artefact to remove, not a standard to uphold.

## Hard rules

- **`integrations/github` is the only provider.** The module never authenticates against Azure. Do not add `azapi`, `azurerm`, `modtm` or `random` provider requirements.
- **No telemetry.** The module collects nothing and makes no network calls beyond the GitHub API. Do not add telemetry resources, data sources or variables. `enable_telemetry` was removed in v2.0.0 and must not come back.
- **No AVM tooling.** `Makefile`, the `avm` / `avm.bat` / `avm.ps1` helpers and the `.github/actions/*` composite actions were removed; they depended on `Azure/avm-terraform-governance`, which is archived and deprecated. Do not run or reinstate `./avm pre-commit`, `./avm pr-check`, `make autofix` or `make pre-commit`. `avmfix` in particular rewrites `terraform.tf` to the AVM provider baseline and would re-add the Azure providers this module deliberately dropped.
- **`for_each` keys are state addresses.** `github_team_repository.this` is keyed by repository name. This module is consumed across many states, so changing a key expression forces a destroy and recreate of every affected grant in every state, and `moved` blocks cannot repair keys computed from a variable. Treat key expressions as immutable unless you are deliberately shipping a migration, and say so explicitly in the pull request.

## Repository layout

```
main.tf                  github_team, github_team_members, github_team_repository
variables.tf             root inputs
outputs.tf               root outputs
terraform.tf             required_version + required_providers
examples/default/        the published example
_header.md / _footer.md  terraform-docs fragments for the root README
```

## Validating

Run these before opening a pull request. They need no Docker, no Azure and no credentials, and they mirror `.github/workflows/ci.yml` exactly:

```bash
terraform fmt -check -recursive -diff

for d in . examples/default; do
  terraform -chdir="$d" init -backend=false -input=false
  terraform -chdir="$d" validate
done

tflint --init
tflint --recursive --minimum-failure-severity=error

terraform-docs -c .terraform-docs.yml .
for e in examples/*/; do terraform-docs -c examples/.terraform-docs.yml "$e"; done
```

Commit any regenerated documentation — CI fails on README drift.

`terraform validate` emits a deprecation warning for `create_default_maintainer` whenever the `resource` output is evaluated. That warning originates in the provider, is reported against the whole-resource output rather than the input, and is expected.

Examples are generated with `examples/.terraform-docs.yml`, not the root config: the example config embeds its own HCL source via `{{ include "main.tf" }}`, which the root config does not.

## Provider constraints worth knowing

These are properties of `integrations/github`, not choices this module is free to make:

- **`github_team_members.members` is `Min: 1`.** A `dynamic "members"` block that
  produces zero blocks fails with `Insufficient members blocks`. Hence the
  `count` guard on the resource — do not remove it without also making membership
  mandatory.
- **`github_team_members` is authoritative.** It removes every user not listed.
- **GitHub auto-promotes a maintainer** when a team has none, and always grants
  organisation owners the maintainer role. Either produces a perpetual diff
  against a `role = "member"` entry. The `maintainers` validation guards the first
  case; the second cannot be detected at plan time and is documented instead.
- **`github_team.create_default_maintainer` and `github_team_members.team_id` are
  deprecated** and are not used. Use `team_slug`. Note `github_team_repository.team_id`
  is *not* deprecated and is still correct.
- **Deprecation warnings fire on known, non-null values.** They do not surface in
  `terraform validate`, because it treats input variables as unknown — which is why
  CI stays green while `terraform plan` warns. The `resource` output is built as an
  explicit object literal rather than `github_team.this` for exactly this reason;
  referencing the whole object reads the deprecated attribute and warns. Add new
  provider attributes to that literal by hand.
- **`etag` is excluded from the `resource` output.** It is the GitHub API's HTTP
  cache validator. The provider sends it as `If-None-Match` on read and stores
  whatever comes back, and GitHub's weak team etags rotate independently of the
  team itself, so including it would make the output change on almost every
  refresh. Provider 6.13 also reports each rotation as external drift; upstream
  has since added `DiffSuppressOnRefresh` to the attribute, but that is unreleased.

## Conventions

- **Commits:** Conventional Commits; `!` marks a breaking change.
- **Identifiers:** `snake_case` throughout.
- **Documentation:** every variable and output carries a `description`.
- **Versioning:** semver. A breaking change means a major bump.
- **Module sources:** registry addresses are `<NAMESPACE>/<NAME>/<PROVIDER>`. The trailing `github` is the *provider* segment, derived from the `terraform-<PROVIDER>-<NAME>` repository naming pattern — it is not a path component.

## Outputs and the team ID

`resource_id` is `github_team.this.id`, the numeric GitHub team ID. Terraform types every resource ID as a **string**, so consumers passing it somewhere typed as a number — notably the `environments[].reviewers.teams` argument of `glueckkanja/gkvm-res-repository/github`, which is `set(number)` — must wrap it in `tonumber()`.

`repository_permissions` exports the `github_team_repository.this` grants keyed by repository name. Consumers that need to break the ordering cycle between team and repository creation should leave `var.repository_permissions` empty and declare `github_team_repository` themselves against this module's `resource_id` or `slug`.

## Further reading

- [`CONTRIBUTING.md`](CONTRIBUTING.md) — contribution workflow and the pull request checklist
- [`SECURITY.md`](SECURITY.md) — vulnerability reporting
