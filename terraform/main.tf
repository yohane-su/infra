terraform {
  cloud {
    organization = "sksat"

    workspaces {
      name = "yohanesu-infra"
    }
  }

  required_version = "1.8.1"
}
