terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "4.57.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.5.0"
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
