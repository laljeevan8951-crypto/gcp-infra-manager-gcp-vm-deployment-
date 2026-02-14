terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.name_prefix}-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name_prefix}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.10.0.0/24"
}

# Allow RDP to Windows VMs (TCP 3389)
resource "google_compute_firewall" "allow_rdp" {
  name    = "${var.name_prefix}-allow-rdp"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rdp"]
}

# Windows VMs
resource "google_compute_instance" "vm" {
  count        = var.vm_count
  name         = "${var.name_prefix}-win-${format("%02d", count.index + 1)}"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["rdp"]

  # --- FIX STARTS HERE ---
  # This block enables Secure Boot to satisfy your Org Policy
  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
  # --- FIX ENDS HERE ---

  boot_disk {
    initialize_params {
      # Windows Server 2022 image
      image = "windows-cloud/windows-2022"
      size  = 50
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }

  labels = {
    env = var.env
    app = var.name_prefix
    os  = "windows"
  }
}
