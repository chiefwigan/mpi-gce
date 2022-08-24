#!/bin/bash

#set our variables
#myBucket=YOUR-BUCKET
myProject=YOUR-PROJECT

echo ######################################################
echo Updating files with your project name: $myProject
echo ######################################################
sed -i "s/YOUR-PROJECT/$myProject/g" *

echo ######################################################
echo Generate random string for bucket
echo ######################################################

rndNum=`echo $RANDOM | md5sum | head -c 20`
#Set bucket name
myBucket="mpi-test-bucket-$rndNum"
gsutil mb gs://"$myBucket"
echo "Bucket Name is: $myBucket"


echo ######################################################
echo Updating files with your random bucket name: $myBucket
echo ######################################################

sed -i "s/YOUR-BUCKET/$myBucket/g" *

echo ######################################################
echo Creating SSH keys and copying files to: $myBucket
echo ######################################################

# Create an ssh key pair with no password
ssh-keygen -t rsa -f ./id_rsa -q -P ""

# Copy cotents of public key to authorized keys
cat id_rsa.pub > authorized_keys

#Copy scripts and keys to bucket
gsutil cp mpi-*.sh gs://$myBucket
gsutil cp id_rsa gs://$myBucket
gsutil cp authorized_keys gs://$myBucket





echo "Unless you see any errors, please go ahead and run:"
echo "terraform init"
echo "terraform apply"