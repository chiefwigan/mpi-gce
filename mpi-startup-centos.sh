#!/bin/bash

# Set our variables
myBucket="YOUR-BUCKET"
startup_script_log="/var/tmp/startup-script.out"

######################################################
#Check if this file has already run and set up log
######################################################

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

######################################################
#Update and Install Pre-requisites
######################################################
sudo yum -y update

# Install wget, git
sudo yum -y install wget git

######################################################
#Install Google HPC Toolkit for Intel MPI Libraries
######################################################
git clone  https://github.com/GoogleCloudPlatform/hpc-tools.git /var/tmp/hpc-tools
sudo chmod 755 /var/tmp/hpc-tools/google_install_mpi 
sudo /var/tmp/hpc-tools/google_install_mpi --intel_mpi

######################################################
#Configure new location for authorized keys
#Configure SSH
######################################################

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

#Copy MPI setup script, ready for use
gsutil cp gs://$myBucket/mpi-env-setup.sh /var/tmp/mpi-env-setup.sh
chmod 755 /var/tmp/mpi-env-setup.sh

######################################################
# Reboot
######################################################
sudo reboot

fi