# Basic MPI Latency Test over Ethernet with Google Compute Engine


## Overview

This project is a simple set of scripts to show microseconds latency between two Google Cloud GCE VMs over Ethernet with the help of [Compact Placement](https://cloud.google.com/compute/docs/instances/define-instance-placement) and Intel MPI libraries (other MPI libraries are available).

## Pre-requisites
- A Google Cloud Platform account
- Ability to create 2 x c2-standard-60 machines (smaller/cheaper machine shapes can be used, but in testing the most powerful of the compute optimize shape gave the best results)
- Sufficient C2 CPU quota in the region of your choice to create the VMs
- Ability to create a GCS bucket

## Files

- `main.tf` - creates 2 x GCE VMs and a compact placement policy to test MPI latency against
- `installation-setup.sh` - creates a randomly named bucket an ssh key-pair and copies the bucket and project name across all files as required.
- `mpi-startup-centos.sh` - sets up the VM and installs Intel MPI (Version 2018 Update 4) via Google's [HPC Tools GitHub repo](https://github.com/GoogleCloudPlatform/hpc-tools.git).
- `mpi-env-setup.sh` - to be run once one the VM you want to run the latency test from.
- `variables.sh` - variables for main.tf including region, number of VMs, project id etc.


## How to install

The below assumes the commands below are being run in Google's Cloud Shell: 

- Via your Google Cloud Console, open up the Cloud Shell
- Clone this repository to a directory of your choice which will create an mpi-gce directory: `git clone https://github.com/chiefwigan/mpi-gce`
- Inside the mpi-gce directory, make installation-setup.sh executable: `chmod 755 installation-setup.sh`, then execute the file with your Google Cloud project_id as a parameter, eg. `./installation_setup.sh my-project`
- In the same directory run: `terraform init`
- In the same directory run: `terraform apply`
- Assuming you're happy (your should see 3 changes to make), confirm with 'Yes'. 2 x GCE VMs should be created in us-central1-f.
- Give the machines a couple of minutes to run their startup script - when successful you should see the line: `source /opt/intel/psxe_runtime/linux/bin/psxevars.sh` presented to you when you SSH to the VMs. If not, log off and give it a few more minutes.
- SSH to `mpi-instance-01` and `mpi-instance-02` either via the Google Cloud Console or from Cloud Shell
- Execute `/var/tmp/mpi-env-setup.sh` on `mpi-instance-01` - this copies ssh keys to the correct place and updates sshd configuration.
- As per the instructions from the above executed file run:  
`source /opt/intel/psxe_runtime/linux/bin/psxevars.sh`  
then    
`mpirun -np 2 -ppn 1 -hosts mpi-instance-01,mpi-instance-02 IMB-MPI1 -iter 10000 PingPong`

In my testing I saw latency of around 8-10 microseconds for the first 512 bytes using the Intel MPI test. Note - I've seen variations of between 8 to 12 microseconds during testing.


## Housekeeping
1. Run `terraform destroy` once finished with your testing
2. Delete the bucket that was created `gsutil rm -r gs://YOUR-BUCKET`
