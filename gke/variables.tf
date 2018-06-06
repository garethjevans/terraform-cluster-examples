variable "gcp_region" {
  description = "GCP region, e.g. us-east1"
}

variable "gcp_zone" {
  description = "GCP zone, e.g. us-east1-b (which must be in gcp_region)"
}

variable "gcp_project" {
  description = "GCP project name"
}

variable "cluster_name" {
  description = "Name of the K8s cluster"
}

variable "min_node_count" {
  description = "Min Number of worker VMs to create"
  default = 3
}

variable "max_node_count" {
  description = "Max Number of worker VMs to create"
  default = 5
}

variable "node_machine_type" {
  description = "GCE machine type"
  default = "n1-standard-2"
}

variable "node_preemptible" {
  description = "Use preemptible nodes"
  default = "false"
}

variable "node_disk_size" {
  description = "Node disk size in GB"
  default = "20"
}
