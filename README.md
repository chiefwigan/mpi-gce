# MPI-GCE

## Overview

This project is a simple set of scripts to show how to get microsecond latency between two Google Cloud GCE nodes using MPI.

## Pre-requisites
- A Google Cloud Plaform account
- Sufficient C2 CPUs quota to spin up 2 x c2-standard-60 machines in the region
- A GCS bucket

## Files

- main.tf - creates 2 x GCE VMs to test MPI latency against
- installation-setup.sh - creates an ssh key-pair and copy to your bucket
- mpi-startup-centos.sh - sets up the VM on boot, installing both OpenMPI and IntelMPI as well as a few other useful tools.
- mpi-env-setup.sh - to be run once on the VM you ssh to, to run the latency test.
- variables.sh - variables for main.tf including region, number of VMs, project id etc.


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
9. SSH to mpi-instance-01
10. Run mpi-env-setup.sh
11. Log onto mpi-instance-02 then exit (this allows SSH to work - there is likely a more sophisticated way to do this!)
12. From mpi-instance-01, run the latency test as required.



