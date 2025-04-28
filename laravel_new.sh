#!/bin/bash

# Check if project name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <project_name>"
  echo "Example: $0 nmclaims.cilanka.com"
  exit 1
fi

# Variables
PROJECT_NAME="$1"
PROJECT_PATH="/var/www/html/$PROJECT_NAME"
LOG_PATH="/var/log/httpd/$PROJECT_NAME"
APACHE_CONF_PATH="/etc/httpd/sites-available/$PROJECT_NAME.conf"

# Ensure script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# Ensure Composer is in the PATH
echo 'export PATH=$PATH:/usr/local/bin' >> /etc/profile.d/composer.sh
source /etc/profile.d/composer.sh

# Create Laravel project using Composer
echo "Creating Laravel project..."
cd /var/www/html
composer create-project --prefer-dist laravel/laravel "$PROJECT_NAME"

# Change ownership of the Laravel project to apache
echo "Setting ownership..."
chown -R deploy:apache "$PROJECT_PATH"
chown -R apache:apache "$PROJECT_PATH"/public
chown -R apache:apache "$PROJECT_PATH"/storage

# Change permissions of the Laravel project
echo "Setting permissions..."
chmod -R 775 "$PROJECT_PATH"

# Create backup folder
echo "Creating backup folder..."
cd /var/www/html/backups
mkdir -p "$PROJECT_NAME"
chown -R deploy:apache "$PROJECT_NAME"

# Create Apache configuration file
echo "Creating Apache configuration..."
cat > "$APACHE_CONF_PATH" <<EOL
<VirtualHost *:80>
    ServerName $PROJECT_NAME
    ServerAlias www.$PROJECT_NAME
    DocumentRoot $PROJECT_PATH/public/

    <Directory "$PROJECT_PATH/">
         Options FollowSymLinks
         AllowOverride All
         Require all granted
    </Directory>

    # Disable TRACE and TRACK methods
    <IfModule mod_rewrite.c>
        RewriteEngine On
        RewriteCond %{REQUEST_METHOD} ^(TRACE|TRACK)
        RewriteRule .* - [F]
    </IfModule>

    ErrorLog $LOG_PATH/error.log
    CustomLog $LOG_PATH/access.log combined
</VirtualHost>
EOL

# Create log directory for the Laravel project
echo "Creating log directory..."
mkdir -p "$LOG_PATH"
chown apache:apache "$LOG_PATH"
chmod 755 "$LOG_PATH"

echo "Laravel project setup completed for $PROJECT_NAME!"