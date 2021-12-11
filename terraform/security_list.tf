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
