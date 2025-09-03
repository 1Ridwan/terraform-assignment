#!/bin/bash
set -euo pipefail

# Packages
dnf -y update
dnf -y install httpd php php-fpm php-mysqlnd php-json php-gd php-xml php-mbstring php-curl php-zip tar curl unzip rsync

# PHP-FPM with Apache
cat >/etc/httpd/conf.d/php-fpm.conf <<'CONF'
<FilesMatch \.php$>
    SetHandler "proxy:unix:/run/php-fpm/www.sock|fcgi://localhost/"
</FilesMatch>
DirectoryIndex index.php index.html
CONF
# Permalinks
sed -ri '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride .*/AllowOverride All/' /etc/httpd/conf/httpd.conf || true

systemctl enable --now php-fpm
systemctl enable --now httpd

# DB (MariaDB)
dnf -y install mariadb105-server || dnf -y install mariadb-server
systemctl enable --now mariadb
mysql <<'SQL'
CREATE DATABASE IF NOT EXISTS wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'wpuser'@'localhost' IDENTIFIED BY 'StrongPassword123';
ALTER USER 'wpuser'@'localhost' IDENTIFIED BY 'StrongPassword123';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
SQL

# WordPress
cd /tmp
curl -fsSLO https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rsync -a --delete wordpress/ /var/www/html/
rm -rf wordpress latest.tar.gz

# Config
if [ ! -f /var/www/html/wp-config.php ]; then
  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
  sed -ri "s/database_name_here/wordpress/; s/username_here/wpuser/; s/password_here/StrongPassword123/" /var/www/html/wp-config.php
  echo "define('FS_METHOD','direct');" >> /var/www/html/wp-config.php  # why: plugin/theme updates without FTP.
  curl -fsS https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-config.php
fi

# Permissions
chown -R root:root /var/www/html
find /var/www/html -type d -exec chmod 0755 {} \;
find /var/www/html -type f -exec chmod 0644 {} \;
install -d -o apache -g apache -m 0755 /var/www/html/wp-content/uploads
touch /var/www/html/.htaccess && chown apache:apache /var/www/html/.htaccess

systemctl reload httpd
