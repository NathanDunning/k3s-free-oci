variable "compartment_id" {
  type        = string
  description = "The id of the compartment where all resources will be created"
}

variable "vcn_display_name" {
  type        = string
  description = "Virtual cloud network name"
  default     = "k3snetwork"
}

variable "vcn_cidr" {
  type        = list(string)
  description = "Virtual cloud network CIDR block"
  default     = ["10.0.0.0/20"]
}

variable "vcn_dns_label" {
  type        = string
  description = "Virtual cloud network DNS label"
  default     = "k3snetwork"
}

variable "nodes_subnet_display_name" {
  type        = string
  description = "Name of the subnet for the public resources"
  default     = "nodes subnet"
}

variable "nodes_subnet_cidr" {
  type        = string
  description = "CIDR of the subnet for the public resources"
  default     = "10.0.0.0/24"
}

variable "nodes_subnet_dns_label" {
  type        = string
  description = "DNS label of the subnet for the public resources"
  default     = "nodes"
}

variable "public_subnet_display_name" {
  type        = string
  description = "Name of the subnet for the Kubernetes nodes"
  default     = "public subnet"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR of the subnet for the Kubernetes nodes"
  default     = "10.0.1.0/24"
}

variable "public_subnet_dns_label" {
  type        = string
  description = "DNS label of the subnet for the Kubernetes nodes"
  default     = "public"
}

variable "instance_display_name" {
  type        = string
  description = "Display name of the instance"
  default     = "k3s-node-1"
}

variable "instance_availability_domain" {
  type        = string
  description = "The availability domain of the instance"
}

variable "instance_fault_domain" {
  type        = string
  description = "The availability domain of the instance"
  default     = "FAULT-DOMAIN-1"
}

variable "instance_shape" {
  type        = string
  description = "Shape of the instance"
  default     = "VM.Standard.A1.Flex"
}

variable "instance_shape_memory" {
  type        = number
  description = "Memory of the instances in GBs"
}

variable "instance_shape_ocpus" {
  type        = number
  description = "OCPUs of the instance"
}

variable "instance_boot_volume_size" {
  type        = number
  description = "Size of the boot volume for the instance in GBs"
  default     = 50
}

variable "instance_boot_volume_vpus" {
  type        = number
  description = "VPUs of the boot volume for the instance per GB"
  default     = 10
}

variable "instance_boot_image_id" {
  type        = string
  description = "Id of the image to use for the instance"
}

variable "instance_agent_config_is_management_disabled" {
  type        = bool
  description = "Prevent Oracle Cloud Agent from gathering performance metrics and monitor the instance using the moniting plugins?"
  default     = false
}

variable "instance_agent_config_is_monitoring_disabled" {
  type        = bool
  description = "Prevent Oracle Cloud Agent from running available management plugins?"
  default     = false
}

variable "instance_availability_config_is_live_migration_preferred" {
  type        = bool
  description = "Is live migration preferred?"
  default     = true
}

variable "instance_availability_config_recovery_action" {
  type        = bool
  description = "The lifecycle state for an instance when it is recovered after infrastructure maintenance"
  default     = "RESTORE_INSTANCE"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the public ssh key"
}

variable "reserved_ip_id" {
  type        = string
  description = "Id of reserved IP to be used for the network load balancer"
  default     = ""
}

variable "network_lb_display_name" {
  type        = string
  description = "Display name of the network load balancer"
}

variable "personal_public_ip" {
  type        = string
  description = "Public IP address of your personal home network. Used for whitelisting backdoor access to your nodes and the KubeAPI"
}

variable "k3s_version" {
  type        = string
  description = "Version of K3s to install"
  default     = "latest"
}


variable "tags" {
  type        = map(string)
  description = "Freeform tags for the resources"
  default     = {}
}
