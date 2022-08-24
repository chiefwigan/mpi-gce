# MPI Latency Test with Google Compute Engine using Compact Placement

## Overview

This project is a simple set of scripts to show how to get microsecond latency between two Google Cloud GCE nodes using Intel MPI (other MPI libraries are available).

## Pre-requisites
- A Google Cloud Platform account
- Ability to create 2 x c2-standard-60 machines
- Sufficient C2 CPU quota in the region of your choice to create the VMs
- Ability to create a GCS bucket

## Files

- `main.tf` - creates 2 x GCE VMs and a compact placement policy to test MPI latency against
- `installation-setup.sh` - creates a randomly names bucket an ssh key-pair and copies the bucket and project name across all files as required.
- `mpi-startup-centos.sh` - sets up the VM and installs IntelMPI via Google's [HPC Tools GitHub repo](https://github.com/GoogleCloudPlatform/hpc-tools.git).
- `mpi-env-setup.sh` - to be run once one the VM you want to run the latency test from.
- `variables.sh` - variables for main.tf including region, number of VMs, project id etc.


## How to install

The below assumes the commands below are being run in Google's Cloud Shell: 

- Via your google Cloud Console, open up the Cloud Shell
- Clone this repository to a directory of your choice which will create an mpi-gce directory
- Inside the mpi-gce directory, make installation-setup.sh executable: `chmod 755 installation-setup.sh`, then execute the file with your project_id as a parameter, eg. `./installation_setup.sh my-project`
- In the same directory run: `terraform init`
- In the same directory run: `terraform apply`
- Assuming you're happy (your should see 3 changes to make), confirm with 'Yes'. 2 x GCE VMs should be created.
- SSH to mpi-instance-01
- Execute `/var/tmp/mpi-env-setup.sh` - this copies ssh keys to the correct place and updates sshd configuration.
- Log onto mpi-instance-02 then logout/exit from mpi-instance-02 (this allows remote SSH - there is likely a more sophisticated way to do this, but in the interest of time, it's not too painful to do!)
- From mpi-instance-01, run the latency test as required.


You should hopefully see latency of around 8-10 microseconds for the first 512 bytes using the Intel MPI test.


## Housekeeping
1. Run `terraform destroy` once finished with your testing
2. Delete the bucket that was created `gsutil rm -r gs://YOUR-BUCKET`