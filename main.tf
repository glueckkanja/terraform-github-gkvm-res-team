resource "github_team" "this" {
  name = var.name

  description    = var.description
  privacy        = var.privacy
  parent_team_id = var.parent_team_id
  ldap_dn        = var.ldap_cdn
}

locals {
  members = concat(
    [
      for member in var.members : {
        username = member
        role     = "member"
      }
    ],
    [
      for maintainer in var.maintainers : {
        username = maintainer
        role     = "maintainer"
      }
    ],
  )
}

moved {
  from = github_team_members.this
  to   = github_team_members.this[0]
}

resource "github_team_members" "this" {
  count = length(local.members) > 0 ? 1 : 0

  team_slug = github_team.this.slug

  dynamic "members" {
    for_each = local.members
    content {
      username = members.value.username
      role     = members.value.role
    }
  }
}

resource "github_team_repository" "this" {
  for_each = {
    for repo in var.repository_permissions : repo.repository => repo
  }
  team_id    = github_team.this.id
  repository = each.value.repository

  permission = each.value.permission
}
