# Variables - change as required

variable "project" {
  default = "YOUR-PROJECT"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-f"
}

variable "machine_type" {
  default = "c2-standard-60"
}

variable "image" {
    default = "cloud-hpc-image-public/hpc-centos-7" # Google Optimized Centos Based HPC Image
}

variable "startup_script" {
    default = "gs://YOUR-BUCKET/mpi-startup-centos.sh"
}

variable "num_vms" {
    default = 2 #Ensure you have enough C2 CPUs quota in the appropriate region
}

variable "placement_policy_name" {
    default = "cp-us-central1"
}

