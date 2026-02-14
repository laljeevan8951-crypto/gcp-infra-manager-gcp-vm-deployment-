output "vm_names" {
  description = "Names of the created VMs"
  value       = google_compute_instance.vm[*].name
}
