# This load balancer uses Oracle's Network Load Balancer as an entrypoint into the cluster
resource "oci_network_load_balancer_network_load_balancer" "public_lb" {
  compartment_id             = var.compartment_id
  display_name               = var.network_lb_display_name
  subnet_id                  = oci_core_subnet.public.id
  network_security_group_ids = [oci_core_network_security_group.public_lb.id]

  is_private                     = false
  is_preserve_source_destination = true

  reserved_ips {
    id = var.reserved_ip_id == "" ? oci_core_public_ip.public_lb_ip.id : var.reserved_ip_id
  }

  freeform_tags = var.tags
}


# HTTP Ingress
resource "oci_network_load_balancer_listener" "k3s_http_listener" {
  name                     = "k3s_http_listener"
  protocol                 = "TCP"
  port                     = 80
  default_backend_set_name = oci_network_load_balancer_backend_set.k3s_http_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_lb.id
}

resource "oci_network_load_balancer_backend_set" "k3s_http_backend_set" {
  health_checker {
    protocol = "TCP"
    port     = 80
  }

  name                     = "k3s_http_backend"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_lb.id
  policy                   = "FIVE_TUPLE"
  is_preserve_source       = true
}

resource "oci_network_load_balancer_backend" "k3s_http_backend" {
  name                     = format("%s:%s", oci_core_instance.node.display_name, 80)
  port                     = 80
  backend_set_name         = oci_network_load_balancer_backend_set.k3s_http_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_lb.id
  target_id                = oci_core_instance.node.id
}


# HTTPS Ingress
resource "oci_network_load_balancer_listener" "k3s_https_listener" {
  name                     = "k3s_https_listener"
  protocol                 = "TCP"
  port                     = 443
  default_backend_set_name = oci_network_load_balancer_backend_set.k3s_https_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_lb.id
}

resource "oci_network_load_balancer_backend_set" "k3s_https_backend_set" {
  health_checker {
    protocol = "TCP"
    port     = 443
  }

  name                     = "k3s_https_backend"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_lb.id
  policy                   = "FIVE_TUPLE"
  is_preserve_source       = true
}

resource "oci_network_load_balancer_backend" "k3s_https_backend" {
  name                     = format("%s:%s", oci_core_instance.node.display_name, 443)
  port                     = 443
  backend_set_name         = oci_network_load_balancer_backend_set.k3s_https_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public_lb.id
  target_id                = oci_core_instance.node.id
}
