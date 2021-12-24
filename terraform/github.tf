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

resource "github_team_membership" "infra_admin_sksat" {
  team_id  = github_team.infra_admin.id
  username = "sksat"
  role     = "maintainer"
}

# user

resource "github_membership" "sksat" {
  username = "sksat"
  role     = "admin"
}
