output "resource" {
  description = <<DESCRIPTION
The `github_team` resource object. Every attribute of the resource is exposed
except the deprecated `create_default_maintainer`, which is omitted so that
consuming this output does not raise the provider's deprecation warning. New
provider attributes are not picked up automatically; add them here.
DESCRIPTION
  value = {
    description           = github_team.this.description
    etag                  = github_team.this.etag
    id                    = github_team.this.id
    ldap_dn               = github_team.this.ldap_dn
    members_count         = github_team.this.members_count
    name                  = github_team.this.name
    node_id               = github_team.this.node_id
    notification_setting  = github_team.this.notification_setting
    parent_team_id        = github_team.this.parent_team_id
    parent_team_read_id   = github_team.this.parent_team_read_id
    parent_team_read_slug = github_team.this.parent_team_read_slug
    privacy               = github_team.this.privacy
    slug                  = github_team.this.slug
  }
}

output "resource_id" {
  description = "The ID of the team. This is the numeric GitHub team ID, but Terraform types every resource ID as a string; wrap it in `tonumber()` where a number is required."
  value       = github_team.this.id
}

output "name" {
  description = "The name of the team."
  value       = github_team.this.name
}

output "slug" {
  description = "The URL slug of the team, in the form used by the GitHub API and by `github_team_repository`."
  value       = github_team.this.slug
}

output "node_id" {
  description = "The GraphQL global node ID of the team, for use with the v4 API."
  value       = github_team.this.node_id
}

output "description" {
  description = "The description of the team, or `null` when none is set."
  value       = github_team.this.description
}

output "privacy" {
  description = "The privacy level of the team."
  value       = github_team.this.privacy
}

output "members_count" {
  description = "The number of members in the team, as reported by GitHub."
  value       = github_team.this.members_count
}

output "repository_permissions" {
  description = "A map of the created repository grants, keyed by repository name."
  value       = { for k, v in github_team_repository.this : k => v }
}
