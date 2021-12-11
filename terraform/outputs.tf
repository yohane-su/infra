data "oci_core_security_lists" "hoge" {
  compartment_id = var.OCID_COMPARTMENT
}

data "oci_core_vcns" "hoge" {
  compartment_id = var.OCID_COMPARTMENT
}

data "oci_core_subnets" "hoge" {
  compartment_id = var.OCID_COMPARTMENT
}


output "hoge" {
  value = data.oci_core_security_lists.hoge
}

output "current_vcns" {
  value = data.oci_core_vcns.hoge
}

output "current_subnets" {
  value = data.oci_core_subnets.hoge
}
