resource "github_team" "this" {
  name = var.name

  description               = var.description
  privacy                   = var.privacy
  parent_team_id            = var.parent_team_id
  ldap_dn                   = var.ldap_cdn
  create_default_maintainer = var.create_default_maintainer
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

resource "github_team_members" "this" {
  team_id = github_team.this.id

  dynamic "members" {
    for_each = local.members
    content {
      username = members.value.username
      role     = members.value.role
    }
  }
}
