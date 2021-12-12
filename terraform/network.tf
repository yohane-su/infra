resource "oci_core_vcn" "ubuntu_vcn" {
  compartment_id = var.OCID_COMPARTMENT

  display_name   = "ubuntu VCN"
  dns_label      = "defaultvcn"
  is_ipv6enabled = false

  cidr_blocks = [
    "10.0.0.0/16"
  ]
}

resource "oci_core_subnet" "ubuntu_subnet" {
  compartment_id = var.OCID_COMPARTMENT

  display_name = "ubuntu subnet"
  dns_label    = "defaultsubnet24"

  vcn_id     = oci_core_vcn.ubuntu_vcn.id
  cidr_block = "10.0.0.0/24"
  #ipv6cidr_block = ""
  route_table_id = oci_core_vcn.ubuntu_vcn.default_route_table_id

  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false

  security_list_ids = [
    oci_core_security_list.egress_rule.id,
    oci_core_security_list.ingress_icmp.id,
    oci_core_security_list.ingress_ssh.id,
  ]
}

resource "oci_core_internet_gateway" "default_oci_core_internet_gateway" {
  compartment_id = var.OCID_COMPARTMENT
  display_name   = "Internet Gateway Default OCI core vcn"
  enabled        = "true"
  vcn_id         = oci_core_vcn.ubuntu_vcn.id
}

resource "oci_core_default_route_table" "default_oci_core_default_route_table" {
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.default_oci_core_internet_gateway.id
  }
  manage_default_resource_id = oci_core_vcn.ubuntu_vcn.default_route_table_id
}
