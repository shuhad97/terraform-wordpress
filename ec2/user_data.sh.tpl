#!/bin/bash
set -e
exec > >(tee /tmp/user_data.log) 2>&1

apt-get update -y
apt-get upgrade -y

DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 php php-mysql mysql-client wget unzip curl

systemctl enable apache2
systemctl start apache2

# Variables passed in from Terraform user data template
RDS_ADDRESS="${rds_address}"
DB_NAME="wordpress"
DB_USER="${db_user}"
DB_PASSWORD="${db_password}"

echo "Address for RDS: $${RDS_ADDRESS}"


for i in $(seq 1 20); do
    mysqladmin ping -h $RDS_ADDRESS -u $DB_USER -p"$DB_PASSWORD" --silent && break
    echo "Waiting for database connection... attempt $i"
    sleep 10
done

mysql -h $RDS_ADDRESS -u $DB_USER -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"

cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

echo "WordPress downloaded successfully"

rm -f /var/www/html/index.html
rm -rf /var/www/html/*
cp -r wordpress/* /var/www/html/

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/$${DB_NAME}/" /var/www/html/wp-config.php
sed -i "s/username_here/$${DB_USER}/" /var/www/html/wp-config.php
sed -i "s/password_here/$${DB_PASSWORD}/" /var/www/html/wp-config.php
sed -i "s/localhost/$${RDS_ADDRESS}/" /var/www/html/wp-config.php

systemctl restart apache2
