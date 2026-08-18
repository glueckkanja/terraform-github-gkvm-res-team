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
