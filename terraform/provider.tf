terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "4.113.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.2.0"
    }

    github = {
      source  = "integrations/github"
      version = "5.24.0"
    }
  }
}

provider "oci" {
  region       = "ap-tokyo-1"
  tenancy_ocid = var.OCID_TENANCY
  user_ocid    = var.OCID_USER
  fingerprint  = var.OCID_FINGERPRINT
  private_key  = var.OCID_PRIVATE_KEY
}

provider "cloudflare" {
  api_token = var.CF_DNS_TOKEN
}

data "cloudflare_zone" "yohanesu" {
  name = "yohane.su"
}

provider "github" {
  owner = "yohane-su"

  # https://registry.terraform.io/providers/integrations/github/latest/docs#github-app-installation
  app_auth {}
}
