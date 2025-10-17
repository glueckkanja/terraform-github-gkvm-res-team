variable "name" {
  type        = string
  description = "(Required) The name of the team."
  nullable    = false

  validation {
    condition     = (length(var.name) >= 2)
    error_message = "The 'name' variable must be at least 2 characters long."
  }
}

variable "description" {
  type        = string
  description = "(Optional) The description of the team."
  default     = null
  nullable    = true
}

variable "privacy" {
  type        = string
  description = "(Optional) The privacy level of the team. Allowed values are 'secret' and 'closed'."
  default     = "secret"
  nullable    = false

  validation {
    condition     = var.privacy == "secret" || var.privacy == "closed"
    error_message = "The 'privacy' variable must be either 'secret' or 'closed'."
  }
}

variable "parent_team_id" {
  type        = string
  description = "(Optional) The ID of the parent team for creating a nested team."
  default     = null
  nullable    = true
}

variable "ldap_cdn" {
  type        = string
  description = "(Optional) The LDAP Distinguished Name of the group where membership will be synchronized. Only available in GitHub Enterprise Server."
  default     = null
  nullable    = true
}

variable "create_default_maintainer" {
  type        = bool
  description = "(Optional) Whether to create a default maintainer for the team."
  default     = false
  nullable    = false
}

variable "members" {
  type        = list(string)
  description = "(Optional) A list of GitHub usernames to add as members of the team."
  default     = []
  nullable    = false
}

variable "maintainers" {
  type        = list(string)
  description = "(Optional) A list of GitHub usernames to add as maintainers of the team."
  default     = []
  nullable    = false
}

variable "repository_permissions" {
  type = list(object({
    repository  = string
    permission  = optional(string, "pull")
  }))
  description = "(Optional) A list of repository permissions to assign to the team."
  default     = []
  nullable    = false
}
