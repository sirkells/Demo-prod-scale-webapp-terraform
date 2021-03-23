# Insert Environment Variables
#!/bin/bash

cd /var/www/html/app/etc/
sed -i "s/rds_host_endpoint/${db_host}/g" env.php
sed -i "s/dfsc_db_name/${db_name}/g" env.php
sed -i "s/dfsc_db_username/${db_username}/g" env.php
sed -i "s/dfsc_db_password/${db_password}/g" env.php
sed -i "s/ecc_host_endpoint/${cache_host}/g" env.php

# Mount media folder on EFS

sudo apt-get update -y
apt-get install nfs-common -y
cd /var/www/html/pub 
mkdir media-backup 
cp -r -L media/. media-backup 
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs-endpoint}:/ media 
cp -r -L media-backup/. media 
chown -R magento:www-data media 
chmod -R 777 media
cd /var/www/html/
bin/magento c:c


# Create Healthcheck file

cd /var/www/html/
touch healthy.html