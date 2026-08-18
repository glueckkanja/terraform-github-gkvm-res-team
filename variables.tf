variable "name" {
  type        = string
  description = "(Required) The name of the team."
  nullable    = false

  validation {
    condition     = (length(var.name) >= 2)
    error_message = "The 'name' variable must be at least 2 characters long."
  }
}

variable "create_default_maintainer" {
  type        = bool
  default     = false
  description = "(Optional) Whether to create a default maintainer for the team."
  nullable    = false
}

variable "description" {
  type        = string
  default     = null
  description = "(Optional) The description of the team."
}

variable "ldap_cdn" {
  type        = string
  default     = null
  description = "(Optional) The LDAP Distinguished Name of the group where membership will be synchronized. Only available in GitHub Enterprise Server."
}

variable "maintainers" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of GitHub usernames to add as maintainers of the team."
  nullable    = false
}

variable "members" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of GitHub usernames to add as members of the team."
  nullable    = false
}

variable "parent_team_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the parent team for creating a nested team."
}

variable "privacy" {
  type        = string
  default     = "secret"
  description = "(Optional) The privacy level of the team. Allowed values are 'secret' and 'closed'."
  nullable    = false

  validation {
    condition     = var.privacy == "secret" || var.privacy == "closed"
    error_message = "The 'privacy' variable must be either 'secret' or 'closed'."
  }
}

variable "repository_permissions" {
  type = list(object({
    repository = string
    permission = optional(string, "pull")
  }))
  default     = []
  description = "(Optional) A list of repository permissions to assign to the team."
  nullable    = false
}
