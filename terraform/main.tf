terraform {
  backend "remote" {
    organization = "sksat"

    workspaces {
      name = "yohanesu-infra"
    }
  }
}

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
    boot_volume_size_in_gbs = "50"
    source_id               = var.OCID_SOURCE
    source_type             = "image"
  }
}

data "oci_core_security_lists" "hoge" {
  compartment_id = var.OCID_COMPARTMENT
}

data "oci_core_vcns" "hoge" {
  compartment_id = var.OCID_COMPARTMENT
}

output "hoge" {
  value = data.oci_core_security_lists.hoge
}

output "current_vcns" {
  value = data.oci_core_vcns.hoge
}

resource "oci_core_security_list" "egress_rule" {
  compartment_id = var.OCID_COMPARTMENT
  vcn_id         = var.OCID_VCN

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"

    destination_type = "CIDR_BLOCK"
    stateless        = false
  }
}

resource "oci_core_security_list" "ingress_icmp" {
  compartment_id = var.OCID_COMPARTMENT
  vcn_id         = var.OCID_VCN

  ingress_security_rules {
    protocol    = "1"
    source_type = "CIDR_BLOCK"
    source      = "0.0.0.0/0"
    stateless   = false

    icmp_options {
      type = 3
      code = 4
    }
  }
  ingress_security_rules {
    protocol    = "1"
    source_type = "CIDR_BLOCK"
    source      = "10.0.0.0/16"
    stateless   = false

    icmp_options {
      type = 3
      code = -1
    }
  }
}

resource "oci_core_security_list" "ingress_ssh" {
  compartment_id = var.OCID_COMPARTMENT
  vcn_id         = var.OCID_VCN

  ingress_security_rules {
    protocol    = "6"
    source_type = "CIDR_BLOCK"
    source      = "0.0.0.0/0"
    stateless   = false

    tcp_options {
      min = 22
      max = 22
    }
  }
}
