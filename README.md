# MPI-GCE

## Overview

This project is a simple set of scripts to show how to get microsecond latency between two Google Cloud GCE nodes using MPI.

## Pre-requisites
- A Google Cloud Plaform account
- Sufficient C2_CPUs quota to spin up 2 x c2-standard-60 machines
- A GCS bucket

## Files

- main.tf - creates 2 x GCE VMs to test MPI latency against
- installation-setup.sh - creates an ssh key-pair and copy to your bucket
- mpi-startup-centos.sh - sets up the VM on boot, installing both OpenMPI and IntelMPI as well as a few other useful tools.
- mpi-env-setup.sh - to be run once on the VM you ssh to, to run the latency test.
- variables.sh - variables for main.tf


## How to install

The below assumes the commands below are being run in Google's Cloud Shell: 

1. Create a bucket - this will be used to host some of the scripts from this repo
2. Clone this repository
3. Replace 'YOUR-BUCKET' in all files with the bucket you created in 
4. Replace 'YOUR-PROJECT' in variables.tf with your project_id
5. In the same directory as the clones repo, run: installation-setup.sh
6. In the same directory run: terraform init
7. In the same directory run: terraform apply
8. Assuming you're happy, confirm with 'Yes' and 2 x GCE VMs should be created.
9. SSH to one of the VMs
10. Run mpi-env-setup.sh
11. Run the Intel or OpenMPI latency test as required.


