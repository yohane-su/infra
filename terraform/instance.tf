resource "oci_core_instance" "generated_oci_core_instance" {
  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }
  availability_domain = "dhYs:AP-TOKYO-1-AD-1"
  compartment_id      = var.OCID_COMPARTMENT
  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip          = "true"
    subnet_id                 = var.OCID_SUBNET
  }
  display_name = "ubuntu-01"
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  is_pv_encryption_in_transit_enabled = "true"
  metadata = {
    "ssh_authorized_keys" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAs3X141dqN0IgcRzUo/0j1XVmy5/BcDD8RrXwygxdaX sksat@yohanesu"
  }
  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = "6"
    ocpus         = "1"
  }
  source_details {
    source_type             = "image"
    boot_volume_size_in_gbs = "50"

    # Ubuntu 20.04
    # https://docs.oracle.com/en-us/iaas/images/image/51111a15-54e5-4af7-adb9-cea542248147/
    source_id = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaaxmfmyofygv4bmv533zrkpt5suie2cl5s5ajfx4f3dqv23c3vccpa"
  }
}

