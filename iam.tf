resource "oci_identity_dynamic_group" "compute_dynamic_group" {
  compartment_id = var.compartment_id
  description    = "Dynamic group which contains all instance in this compartment"
  matching_rule  = "All {instance.compartment.id = '${var.compartment_id}'}"
  name           = "Compute_Dynamic_Group"

  freeform_tags = var.tags
}

resource "oci_identity_policy" "compute_dynamic_group_policy" {
  compartment_id = var.compartment_id
  description    = "Policy to allow dynamic group ${oci_identity_dynamic_group.compute_dynamic_group.name} to read instance-family and compute-management-family in the compartment"
  name           = "Compute_To_Oci_Api_Policy"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.compute_dynamic_group.name} to read instance-family in compartment id ${var.compartment_id}",
    "allow dynamic-group ${oci_identity_dynamic_group.compute_dynamic_group.name} to read compute-management-family in compartment id ${var.compartment_id}"
  ]

  freeform_tags = var.tags
}
