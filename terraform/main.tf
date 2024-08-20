terraform {
  cloud {
    organization = "sksat"

    workspaces {
      name = "yohanesu-infra"
    }
  }

  required_version = "1.9.5"
}
