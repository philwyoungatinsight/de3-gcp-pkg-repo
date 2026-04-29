resource "google_container_cluster" "this" {
  name     = var.cluster_name
  location = var.location

  # Remove the default node pool so we can manage it separately via
  # google_container_node_pool. GKE requires at least one node to create
  # the cluster, so initial_node_count = 1 is needed even though the
  # default pool is immediately removed.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  deletion_protection = var.deletion_protection

  # VPC-native (alias IP) mode — required for private clusters and Workload Identity.
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }

  dynamic "workload_identity_config" {
    for_each = var.workload_pool != "" ? [1] : []
    content {
      workload_pool = var.workload_pool
    }
  }

  resource_labels = var.labels
}

resource "google_container_node_pool" "primary" {
  name       = var.node_pool_name
  location   = var.location
  cluster    = google_container_cluster.this.name
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    oauth_scopes = var.oauth_scopes
  }

  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }
}
