Run this ./laravel_new.sh <Project_Name>

This will create vertual host file
  /etc/httpd/sites-available/<Project_Name>.conf

This will create log file
  /var/log/httpd/<Project_Name>/access.log
  /var/log/httpd/<Project_Name>/error.log
  
This will create backup folder
  /var/www/html/backups/<Project_Name>

Folder permission
  parth /var/www/html/<Project_Name>
    Owner - deploy
    Group - apache
    Permission - rwx-rwx-wx

  parth /var/www/html/<Project_Name>/public
    Owner - apache
    Group - apache
    Permission - rwx-rwx-wx

  parth /var/www/html/<Project_Name>/storage
    Owner - apache
    Group - apache
    Permission - rwx-rwx-wx

   parth /var/www/html/backups/<Project_Name>
    Owner - deploy
    Group - apache
    Permission - rwx-rwx-wx

   parth /var/log/httpd/<Project_Name>
   Owner - apache
    Group - apache
    Permission - rwx-rx-wx
