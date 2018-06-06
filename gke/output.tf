output "cluster_endpoint" {
  value = "${google_container_cluster.jx-cluster.endpoint}"
}

output "cluster_master_version" {
  value = "${google_container_cluster.jx-cluster.master_version}"
}

output "cluster_master_auth_client_certificate" {
  value = "${google_container_cluster.jx-cluster.master_auth.0.client_certificate}"
}

output "cluster_master_auth_client_key" {
  value = "${google_container_cluster.jx-cluster.master_auth.0.client_key}"
}

output "cluster_master_auth_cluster_ca_certificate" {
  value = "${google_container_cluster.jx-cluster.master_auth.0.cluster_ca_certificate}"
}
