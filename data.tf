data "cloudinit_config" "template" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/configure-node.sh", {
      k3s_version     = "${var.k3s_version}",
      k3s_subnet_cidr = "${var.nodes_subnet_cidr}",
      public_lb_ip    = "${oci_core_public_ip.public_lb_ip.ip_address}",
    })
  }
}
