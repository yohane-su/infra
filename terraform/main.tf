terraform {
  backend "remote" {
    organization = "sksat"

    workspaces {
      name = "yohanesu-infra"
    }
  }

  required_version = "1.1.2"
}
