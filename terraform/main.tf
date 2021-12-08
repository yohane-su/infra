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
    subnet_id                 = oci_core_subnet.ubuntu_subnet.id
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

data "oci_core_subnets" "hoge" {
  compartment_id = var.OCID_COMPARTMENT
}

output "current_subnets" {
  value = data.oci_core_subnets.hoge
}

resource "oci_core_subnet" "ubuntu_subnet" {
  compartment_id = var.OCID_COMPARTMENT

  vcn_id         = oci_core_vcn.ubuntu_vcn.id
  cidr_block     = "10.0.0.0/24"
  ipv6cidr_block = ""

  dns_label                  = "subnet08240556"
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false

  security_list_ids = [
    oci_core_security_list.egress_rule.id,
    oci_core_security_list.ingress_icmp.id,
    oci_core_security_list.ingress_ssh.id,
  ]
}

resource "oci_core_vcn" "ubuntu_vcn" {
  compartment_id = var.OCID_COMPARTMENT

  dns_label      = "vcn08240556"
  is_ipv6enabled = false

  cidr_blocks = [
    "10.0.0.0/16"
  ]
}

resource "oci_core_security_list" "egress_rule" {
  compartment_id = var.OCID_COMPARTMENT
  vcn_id         = oci_core_vcn.ubuntu_vcn.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"

    destination_type = "CIDR_BLOCK"
    stateless        = false
  }
}

resource "oci_core_security_list" "ingress_icmp" {
  compartment_id = var.OCID_COMPARTMENT
  vcn_id         = oci_core_vcn.ubuntu_vcn.id

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
  vcn_id         = oci_core_vcn.ubuntu_vcn.id

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
