#!/bin/bash

# Set our variables
myBucket="mpi-test-bucket-20220705"

echo "*************************************"
echo "Setting up SSH configuration"
echo "*************************************"

mkdir ~/.ssh
chmod 700 ~/.ssh 
gsutil cp gs://$myBucket/mpi-key ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

touch ~/.ssh/config
echo "Host *" > ~/.ssh/config
echo " StrictHostKeyChecking no" >> ~/.ssh/config
chmod 644 ~/.ssh/config



echo "*************************************"
echo "Complete"
echo "For OpenMPI please run:"
echo "/usr/lib64/openmpi/bin/mpirun -v -np 2 -hostfile /var/tmp/mpihosts /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency"
echo .
echo "For Intel MPI please run:"
echo "source /opt/intel/psxe_runtime/linux/bin/psxevars.sh"
echo "then:"
ehco "mpirun -np 2 -ppn 1 -hosts mpi-instance-01,mpi-instance-02 IMB-MPI1 PingPong"
echo "*************************************"
