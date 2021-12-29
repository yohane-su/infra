resource "oci_core_instance" "a1flex_instance01" {
  compartment_id      = var.OCID_COMPARTMENT
  availability_domain = "dhYs:AP-TOKYO-1-AD-1"
  fault_domain        = "FAULT-DOMAIN-2"

  display_name = "arm-ubuntu-01"
  shape        = "VM.Standard.A1.Flex"

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

  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip          = "true"
    subnet_id                 = oci_core_subnet.ubuntu_subnet.id
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }

  is_pv_encryption_in_transit_enabled = "true"

  metadata = {
    "ssh_authorized_keys" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAs3X141dqN0IgcRzUo/0j1XVmy5/BcDD8RrXwygxdaX sksat@yohanesu"
  }
}

resource "oci_core_instance" "x86_test_instance" {
  compartment_id      = var.OCID_COMPARTMENT
  availability_domain = "dhYs:AP-TOKYO-1-AD-1"
  fault_domain        = "FAULT-DOMAIN-2"

  display_name = "x86-ubuntu-01"
  shape        = "VM.Standard.E2.1.Micro"

  shape_config {
    memory_in_gbs = "1"
    ocpus         = "1"
  }

  source_details {
    source_type             = "image"
    boot_volume_size_in_gbs = "50"

    # Ubuntu 20.04 Minimal
    # https://docs.oracle.com/en-us/iaas/images/image/cc6e4086-515b-4254-99ea-171acc5e7460/
    source_id = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaato55by5l2yabyitrv62utowyisopehtvqbjrui6vympbi5b57k7q"
  }

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

  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip          = "true"
    subnet_id                 = oci_core_subnet.ubuntu_subnet.id
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }

  is_pv_encryption_in_transit_enabled = "true"

  metadata = {
    "ssh_authorized_keys" = "${file("./init_authorized_keys")}"
  }
}
