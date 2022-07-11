myBucket = YOUR-BUCKET

#Copy startup script and env script to bucket
gsutil cp mpi-*.sh gs://$myBucket

# Create an ssh key pair with no password
ssh-keygen -t rsa -f id_rsa -q -P ""

# Copy cotents of public key to authorized keys
cat id_rsa.pub >> authorized_keys

# Copy keys to bucket
gsutil cp id_rsa gs://$myBucket
gsutil cp authorized_keys gs://$myBucket
