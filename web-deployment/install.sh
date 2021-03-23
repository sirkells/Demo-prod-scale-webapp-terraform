#!/bin/bash  

# Installing PHP & Zip

LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
apt-get update
apt-get install php7.2 libapache2-mod-php7.2 php7.2-mysql php7.2-soap php7.2-bcmath php7.2-xml php7.2-mbstring php7.2-gd php7.2-common php7.2-cli php7.2-curl php7.2-intl php7.2-zip zip unzip -y
apt-get install zip -y

# Installing AWS CLI

cd ~/
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install Apache

apt-get install apache2 -y

# Update configuration files

cd /etc/apache2/mods-enabled/
sed -i "s/index.html index.cgi index.pl index.php index.xhtml index.htm/index.php index.cgi index.pl index.html index.xhtml index.htm/g" dir.conf

cd /etc/apache2/sites-available/
cat <<EOT >> 000-default.conf
<Directory "/var/www/html">
AllowOverride All
</Directory>
EOT

# Enable Rewrite

a2enmod rewrite
systemctl restart apache2

# Update firewall Rule

ufw allow 'Apache Full'

# Install MySql Server

debconf-set-selections <<< 'mysql-server mysql-server/root_password password supersecretpassword'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password supersecretpassword'
apt-get install mysql-server -y

# Install Redis Server

LC_ALL=C.UTF-8 add-apt-repository -y ppa:chris-lea/redis-server
apt-get update
sudo apt-get install redis-server -y
systemctl restart redis-server


# Add and configure magento user

adduser --disabled-password --gecos "" magento
usermod -g www-data magento

# Download Application Code
cd ~/
aws s3 cp s3://demo-fitnessapp-23/app-code.zip .
unzip app-code.zip
rm -rf app-code.zip
cd /var/www/html
rm -rf index.html
cp -r ~/app-code/. .
rm -rf ~/app-code/
chown -R magento:www-data /var/www/html/
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + && chown -R :www-data . && chmod u+x bin/magento