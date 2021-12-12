resource "oci_core_subnet" "ubuntu_subnet" {
  compartment_id = var.OCID_COMPARTMENT

  vcn_id         = var.OCID_VCN
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
