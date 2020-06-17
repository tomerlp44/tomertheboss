#!/bin/bash
#add fix to exercise3 here
cd /etc/apache2/sites-available
apt-get install rpl
rpl -i -w "deny from all" "Allow from all" default
rpl -i -w "AllowOverride None" " AllowOverride All" default
service apache2 restart