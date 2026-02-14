variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  default     = "europe-west2"
  description = "GCP region"
}

variable "zone" {
  type        = string
  default     = "europe-west2-a"
  description = "GCP zone"
}

variable "name_prefix" {
  type        = string
  default     = "gcpvm-im"
  description = "Prefix for resource names"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "Environment label"
}

variable "vm_count" {
  type        = number
  default     = 3
  description = "Number of VMs"
}

variable "machine_type" {
  type        = string
  default     = "e2-medium"
  description = "Compute Engine machine type"
}
