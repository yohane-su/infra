locals {
  users_infra_admin = [
    "sksat",
  ]
  users_infra = [
  ]
  users_craft_dev = [
    "sksat",
    "kory33",
  ]
  users_crafter = [
    "sozysozbot",
  ]
}

# repository
resource "github_repository" "test" {
  name        = "test"
  description = "test repo"

  visibility = "public"
}

# team
## https://docs.github.com/ja/rest/reference/teams#create-a-team--parameters
##   privacy=secret: only visible to organization owners and members of this team.
##   privacy=closed: visible to all members of this organization.

resource "github_team" "infra" {
  name        = "infra"
  description = "infra team"
  privacy     = "closed"
}

resource "github_team" "infra_admin" {
  parent_team_id = github_team.infra.id
  name           = "infra-admin"
  description    = "infra admin"
  privacy        = "closed"
}

resource "github_team" "crafter" {
  name        = "crafter"
  description = "Minecraft player"
  privacy     = "closed"
}

resource "github_team" "craft_dev" {
  parent_team_id = github_team.crafter.id
  name           = "craft-dev"
  description    = "Minecraft developer"
  privacy        = "closed"
}

# team membership

resource "github_team_membership" "infra_admin" {
  team_id = github_team.infra_admin.id

  for_each = toset(local.users_infra_admin)
  username = each.value
  role     = each.value == "sksat" ? "maintainer" : "member"
}

resource "github_team_membership" "infra" {
  team_id = github_team.infra.id

  for_each = toset(local.users_infra)
  username = each.value
  role     = "member"
}

resource "github_team_membership" "craft_dev" {
  team_id = github_team.craft_dev.id

  for_each = toset(local.users_craft_dev)
  username = each.value
  role     = "member"
}

resource "github_team_membership" "crafter" {
  team_id = github_team.crafter.id

  for_each = toset(local.users_crafter)
  username = each.value
  role     = "member"
}

# all users
resource "github_membership" "users" {
  role = each.value == "sksat" ? "admin" : "member"

  for_each = toset(concat(
    local.users_infra_admin,
    local.users_infra,
    local.users_craft_dev,
    local.users_crafter,
  ))
  username = each.value
}
