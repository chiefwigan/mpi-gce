# Variables - change as required

variable "project" {
  default = "rp-test-project-306316"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "machine_type" {
  default = "c2-standard-60"
}

variable "image" {
    default = "cloud-hpc-image-public/hpc-centos-7" # Google Optimized Centos Based HPC Image
}

variable "startup_script" {
    default = "gs://rp-mpi-startup-scripts-01/mpi-startup-centos.sh"
}

variable "num_vms" {
    default = 3 #Ensure you have enough quota!
}

variable "placement_policy_name" {
    default = "cp-us-central1"
}

