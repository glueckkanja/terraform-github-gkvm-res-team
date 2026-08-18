output "resource" {
  description = "The full `github_team` resource object."
  value       = github_team.this
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
