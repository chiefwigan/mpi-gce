#!/bin/bash

# Set our variables
myBucket="rp-mpi-startup-scripts-01"

echo "*************************************"
echo "Setting up SSH configuration"
echo "*************************************"

mkdir ~/.ssh
chmod 700 ~/.ssh 
#gsutil cp gs://rp-mpi-startup-scripts-01/mpi-key ~/.ssh/id_rsa
gsutil cp gs://$myBucket/mpi-key ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

touch ~/.ssh/config
echo "Host *" > ~/.ssh/config
echo " StrictHostKeyChecking no" >> ~/.ssh/config
chmod 644 ~/.ssh/config

echo "If you want to test Intel MPI run: source /opt/intel/psxe_runtime/linux/bin/psxevars.sh"

echo "*************************************"
echo "Finished. Please run:"
echo "/usr/lib64/openmpi/bin/mpirun -v -np 2 -hostfile /var/tmp/mpihosts /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency"
echo "*************************************"
