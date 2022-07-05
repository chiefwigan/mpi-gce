terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}
provider "google-beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}


###############################################################################
# Create GCE VMs
###############################################################################

resource "google_compute_instance" "vm_instance" {
  provider = google-beta
  count = var.num_vms # Set this to the same number as vm_count in the above Compact Placement policy.

  name = format("mpi-instance-0%s", count.index + 1)
  machine_type = var.machine_type
  zone = var.zone
  
  metadata = {
    startup-script-url = var.startup_script
  }
  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  service_account {
    scopes = ["storage-ro"] # Scope required to read from GCS bucket
  }

  scheduling {
    # Instances with resource policies do not support live migration.
    on_host_maintenance = "TERMINATE"
    automatic_restart   = false # This isn't mentioned as a dependency in the TF documentation re compact placement
   }
  
  advanced_machine_features {
    threads_per_core = 1 # When running TF apply, this is an update to the VMs, but looks like it wants to create additional VMs & complains. Perhaps need to delete VMs first.
  }

  #resource_policies = [google_compute_resource_policy.cp-us-central1.id]
  resource_policies = [google_compute_resource_policy.compact_placement_policy.id]
}

###############################################################################
# Create Compact Placement Policy
###############################################################################

resource "google_compute_resource_policy" "compact_placement_policy" {
  provider = google-beta
  name   = var.placement_policy_name
  region = var.region
  group_placement_policy {
    vm_count = var.num_vms  # This needs to be the same as the # of VMs created.
    collocation = "COLLOCATED"
  }
}