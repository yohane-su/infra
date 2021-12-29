terraform {
  backend "remote" {
    organization = "sksat"

    workspaces {
      name = "yohanesu-infra"
    }
  }

  required_version = "${file(.terraform-version)}"
}
