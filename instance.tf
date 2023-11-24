resource "oci_core_instance" "node" {
  #Required
  availability_domain = var.instance_availability_domain
  compartment_id      = var.compartment_id
  shape               = var.instance_shape

  #Optional
  display_name = var.instance_display_name
  fault_domain = var.instance_fault_domain

  agent_config {
    is_management_disabled = var.instance_agent_config_is_management_disabled
    is_monitoring_disabled = var.instance_agent_config_is_monitoring_disabled

    plugins_config {
      desired_state = "ENABLED"
      name          = "Vulnerability Scanning"
    }

    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }

    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }

  availability_config {
    is_live_migration_preferred = var.instance_availability_config_is_live_migration_preferred
    recovery_action             = var.instance_availability_config_recovery_action
  }

  create_vnic_details {
    assign_public_ip = true
    display_name     = "${var.instance_display_name}-VNIC"
    nsg_ids          = [oci_core_network_security_group.nodes.id]
    subnet_id        = oci_core_subnet.nodes.id
  }

  shape_config {
    memory_in_gbs = var.instance_shape_memory
    ocpus         = var.instance_shape_ocpus
  }

  source_details {
    #Required
    source_id   = var.instance_boot_image_id
    source_type = "image"

    #Optional
    boot_volume_size_in_gbs = var.instance_boot_volume_size
    boot_volume_vpus_per_gb = var.instance_boot_volume_vpus
  }

  metadata = {
    "ssh_authorized_keys" = file(var.ssh_public_key_path)
    "user_data"           = data.cloudinit_config.template.rendered
  }

  freeform_tags = var.tags
}
