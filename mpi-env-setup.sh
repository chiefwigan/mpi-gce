#!/bin/bash

# Set our variables
myBucket="YOUR-BUCKET"

echo "****************************************"
echo "Setting up SSH configuration"
echo "****************************************"

gsutil -q cp gs://$myBucket/id_rsa ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

touch ~/.ssh/config
echo "Host *" > ~/.ssh/config
echo " StrictHostKeyChecking no" >> ~/.ssh/config
chmod 644 ~/.ssh/config

echo "****************************************"
echo "Complete"
echo "****************************************"
echo "Please log into mpi-instance-02 before running below commands to allow SSH to function correctly (there is likely a better way to do this)"
echo "For Intel MPI please run:"
echo "source /opt/intel/psxe_runtime/linux/bin/psxevars.sh"
echo "then:"
echo "mpirun -np 2 -ppn 1 -hosts mpi-instance-01,mpi-instance-02 IMB-MPI1 -iter 10000 PingPong"
echo "****************************************"
