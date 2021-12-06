terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
      version = "4.44.0"
    }
  }
}

provider "oci" {
  region           = "ap-tokyo-1"
  tenancy_ocid     = var.OCID_TENANCY
  user_ocid        = var.OCID_USER
  fingerprint      = var.OCID_FINGERPRINT
  private_key_path = var.OCID_PRIVATE_KEY_PATH
}
