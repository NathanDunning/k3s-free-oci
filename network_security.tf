# Security Lists
resource "oci_core_default_security_list" "main" {
  compartment_id             = var.compartment_id
  manage_default_resource_id = oci_core_vcn.main.default_security_list_id

  display_name = "Default security list"

  ingress_security_rules {
    protocol = 1 # icmp
    source   = var.personal_public_ip

    description = "Allow ICMP from personal ip"

  }

  ingress_security_rules {
    protocol = 6 # tcp
    source   = var.personal_public_ip

    description = "Allow SSH from personal ip"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = 6 # tcp
    source   = var.personal_public_ip

    description = "Allow KubeAPI from personal ip"

    tcp_options {
      min = 6443
      max = 6443
    }
  }


  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  freeform_tags = var.tags
}


# Network Security Groups
## Public Load Balancer
resource "oci_core_network_security_group" "public_lb" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "Public LB NSG"

  freeform_tags = var.tags
}


#TODO: Change to access from cloudflare
resource "oci_core_network_security_group_security_rule" "allow_http_from_all" {
  network_security_group_id = oci_core_network_security_group.public_lb_nsg.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp

  description = "Allow HTTP inbound"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

#TODO: Change to access from cloudflare
resource "oci_core_network_security_group_security_rule" "allow_https_from_all" {
  network_security_group_id = oci_core_network_security_group.public_lb_nsg.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp

  description = "Allow HTTPS inbound"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

## Server Compute Instance/Nodes
resource "oci_core_network_security_group" "nodes" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "Public LB to Nodes NSG"

  freeform_tags = var.tags
}

resource "oci_core_network_security_group_security_rule" "nsg_to_instances_http" {
  network_security_group_id = oci_core_network_security_group.nodes.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp

  description = "Allow HTTP inbound from Public LB"

  source      = oci_core_network_security_group.public_lb.id
  source_type = "NETWORK_SECURITY_GROUP"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "nsg_to_instances_https" {
  network_security_group_id = oci_core_network_security_group.nodes.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp

  description = "Allow HTTPS inbound from Public LB"

  source      = oci_core_network_security_group.public_lb.id
  source_type = "NETWORK_SECURITY_GROUP"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}
