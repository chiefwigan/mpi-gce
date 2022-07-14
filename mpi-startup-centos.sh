#!/bin/bash

# Set our variables
myBucket="YOUR-BUCKET"
startup_script_log="/var/tmp/startup-script.out"


# Check if the startup script has run before
FILE=$startup_script_log
if [ -f "$FILE" ]; then
echo "$FILE exists. Startup Script has executed already."
exit
else 
echo "$FILE does not exist. Startup script has not run"

# Log everything - probably a little excessive, but good to be able to see what's going on.
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>$startup_script_log 2>&1

#######################
#Install Pre-requisites
#######################
sudo -y yum update

# Install wget, git
sudo yum -y install wget git

# Install OpenMPI for CentOS
sudo yum -y install openmpi openmpi-devel

# Install Centos development tools
sudo yum -y group install "Development Tools"


#######################
# Install OSU benchmarks
#######################
wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.8.tgz
tar -xvzf osu-micro-benchmarks-5.8.tgz
cd osu-micro-benchmarks-5.8
./configure CC=/usr/lib64/openmpi/bin/mpicc CXX=/usr/lib64/openmpi/bin/mpicxx
make; sudo make install
cd ..

#######################
#Install Google HPC Toolkit for Intel MPI Libraries
#######################
git clone  https://github.com/GoogleCloudPlatform/hpc-tools.git /var/tmp/hpc-tools
sudo chmod 755 /var/tmp/hpc-tools/google_install_mpi 
sudo /var/tmp/hpc-tools/google_install_mpi --intel_mpi

###########################################
#Configure new location for authorized keys
###########################################

#Update sshd_config
vim /etc/ssh/sshd_config
sed -i 's/.ssh\/authorized_keys/.ssh\/authorized_keys \/etc\/ssh\/authorized_keys/g' /etc/ssh/sshd_config

#Copy authorized keys to new location
gsutil cp gs://$myBucket/authorized_keys /etc/ssh

#Update permissions on key files
chmod 644 /var/tmp/id_rsa
chmod 644 /etc/ssh/authorized_keys

#Reload sshd
systemctl reload sshd

#######################
#Add hosts to host file for MPI run.
#######################
echo "mpi-instance-01 slots=1 max_slots=1" > /var/tmp/mpihosts
echo "mpi-instance-02  slots=1 max_slots=1" >> /var/tmp/mpihosts


#Copy MPI setup script, ready for use
gsutil cp gs://$myBucket/mpi-env-setup.sh /var/tmp/mpi-env-setup.sh
chmod 755 /var/tmp/mpi-env-setup.sh


#######################
# Reboot
#######################
sudo reboot

fi