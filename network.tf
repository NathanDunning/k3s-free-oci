resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_id

  cidr_blocks  = var.vcn_cidr
  display_name = var.vcn_display_name
  dns_label    = var.vcn_dns_label

  freeform_tags = var.tags
}

resource "oci_core_internet_gateway" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id

  enabled      = true
  display_name = "Internet Gateway for k3networkvcn"

  freeform_tags = var.tags
}

resource "oci_core_default_route_table" "main" {
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.main.id
  }

  manage_default_resource_id = oci_core_vcn.main.default_route_table_id
}

resource "oci_core_subnet" "nodes" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id

  display_name = var.nodes_subnet_display_name
  cidr_block   = var.nodes_subnet_cidr
  dns_label    = var.nodes_subnet_dns_label

  route_table_id = oci_core_vcn.main.default_route_table_id
  # security_list_ids = [oci_core_default_security_list.main.id]

  freeform_tags = var.tags
}

resource "oci_core_subnet" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id

  display_name = var.public_subnet_display_name
  cidr_block   = var.public_subnet_cidr
  dns_label    = var.public_subnet_dns_label

  route_table_id = oci_core_vcn.main.default_route_table_id
  # security_list_ids = [oci_core_default_security_list.main.id]

  freeform_tags = var.tags
}
