#!/bin/bash

# Install Packages

sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo systemctl start mariadb
sudo systemctl start httpd
sudo systemctl enable httpd



# wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
# sudo yum localinstall -y mysql57-community-release-el7-8.noarch.rpm
#sudo yum install -y mysql-community-server 
# sudo systemctl enable mysqld 
# sudo systemctl start mysqld 




# DOWNLOAD DATABASE FROM S3 BUCKET

cd ~/
aws s3 cp s3://demo-fitnessapp-23/database.zip .
unzip database.zip

# IMPORT DATABASE TO RDS INSTANCE

cd database
mysql -h ${db_host} -u ${db_username} -p${db_password} magento < magento.sql

# UPDATE WEBSTIE DOMAIN

mysql -h ${db_host} -u ${db_username} -p${db_password} -D ${db_name} --execute="UPDATE core_config_data SET value = 'https://www.demofitnessshop.com' WHERE path LIKE 'web/unsecure/base_url'; UPDATE core_config_data SET value = 'https://www.demofitnessshop.com' WHERE path LIKE 'web/secure/base_url';"

# UPDATE MEDIA DOMAIN

mysql -h ${db_host} -u ${db_username} -p${db_password} -D ${db_name} << "EOF"
INSERT INTO `core_config_data` (`config_id`,`scope`,`scope_id`,`path`,`value`,`updated_at`) VALUES ('34','default',0,'web/unsecure/base_media_url',"https://cdn.demofitnessshop.com/pub/media/","2020-03-24 20:26:15");
EOF
mysql -h ${db_host} -u ${db_username} -p${db_password} -D ${db_name} << "EOF"
INSERT INTO `core_config_data` (`config_id`,`scope`,`scope_id`,`path`,`value`,`updated_at`) VALUES ('35','default',0,'web/secure/base_media_url',"https://cdn.demofitnessshop.com/pub/media/","2020-03-24 20:26:15");
EOF