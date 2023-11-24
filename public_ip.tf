# Reserve a public IP for public load balancer
resource "oci_core_public_ip" "public_lb_ip" {
  count = var.reserved_ip_id == "" ? 1 : 0

  #Required
  compartment_id = var.compartment_id
  lifetime       = "RESERVED"

  #Optional
  display_name = "public-lb-ip"

  freeform_tags = var.tags
}
