#!/bin/bash
set -e
exec > >(tee /tmp/user_data.log) 2>&1

# Update packages
apt-get update -y
apt-get upgrade -y

# Install Apache, PHP, MySQL, wget, unzip, curl
DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 php php-mysql mysql-server wget unzip curl

# Enable and start services
systemctl enable apache2
systemctl start apache2
systemctl enable mysql
systemctl start mysql

# Wait for MySQL to fully start
until systemctl is-active --quiet mysql; do
  echo "Waiting for MySQL to start..."
  sleep 3
done

# Set MySQL root password and authentication plugin
MYSQL_ROOT_PASSWORD="${mysql_root_password}"   
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$${MYSQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

echo "root succesfully logged in"

# Create WordPress database and user
DB_NAME="wordpress"
DB_USER="${db_user}"    
DB_PASSWORD="${db_password}"  

mysql -u root -p$${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS \`$${DB_NAME}\`;"
mysql -u root -p$${MYSQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS '$${DB_USER}'@'localhost' IDENTIFIED BY '$${DB_PASSWORD}';"
mysql -u root -p$${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON \`$${DB_NAME}\`.* TO '$${DB_USER}'@'localhost';"
mysql -u root -p$${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

echo "Database created sucessfully"


# Download and set up WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

echo "WordPress downloaded successfully"

# Remove default Apache page and copy WordPress
rm -f /var/www/html/index.html
rm -rf /var/www/html/*
cp -r wordpress/* /var/www/html/

# Set correct permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Configure wp-config.php
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/$${DB_NAME}/" /var/www/html/wp-config.php
sed -i "s/username_here/$${DB_USER}/" /var/www/html/wp-config.php
sed -i "s/password_here/$${DB_PASSWORD}/" /var/www/html/wp-config.php
sed -i "s/localhost/localhost/" /var/www/html/wp-config.php

# Restart Apache to apply changes
systemctl restart apache2
