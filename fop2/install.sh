#!/bin/bash

__mysql_config() {
echo "Running the mysql_config function."	
/usr/bin/mysqld_safe & 
sleep 10
}

__start_mysql() {
echo "Running the start_mysql function."
MYSQL_ROOT_PW=`head -c 200 /dev/urandom | tr -cd 'A-Za-z0-9' | head -c 20`
FOP2_DB_PW=`head -c 200 /dev/urandom | tr -cd 'A-Za-z0-9' | head -c 20`

echo "MYSQL_ROOT_PW ->$MYSQL_ROOT_PW<-" >> /etc/fop2.conf
echo "FOP2_DB_PW ->$FOP2_DB_PW<-" >> /etc/fop2.conf

mysqladmin -u root password $MYSQL_ROOT_PW 
mysql -uroot -p$MYSQL_ROOT_PW -e "CREATE DATABASE IF NOT EXISTS fop2"
mysql -uroot -p$MYSQL_ROOT_PW -e "GRANT ALL PRIVILEGES ON fop2.* TO fop2@localhost IDENTIFIED BY '$FOP2_DB_PW';"
killall mysqld
sleep 10
}

__install_fop2() {
# Install Fop2
wget http://www.fop2.com/download/centos64 -O /usr/src/fop2.tgz
cd /usr/src
tar zxvf fop2.tgz
cd /usr/src/fop2
make install
}

__configure_fop2() {
echo "Configuration file fop2.cfg"
sed -i "s/\(manager_host*\)\(.*\)/\1=$FOP2_AMI_HOST/" /usr/local/fop2/fop2.cfg
sed -i "s/\(manager_port*\)\(.*\)/\1=$FOP2_AMI_PORT/" /usr/local/fop2/fop2.cfg
sed -i "s/\(manager_user*\)\(.*\)/\1=$FOP2_AMI_USER/" /usr/local/fop2/fop2.cfg 
sed -i "s/\(manager_secret*\)\(.*\)/\1=$FOP2_AMI_SECRET/" /usr/local/fop2/fop2.cfg

echo "Configuration Front-end fop2"
sed -i "s/^\s*\$DBPASS\s*=\s*'.*'\s*;\s*/\$DBPASS = '$FOP2_DB_PW';/g" /var/www/html/fop2/config.php

#Configuration back-end fop2
sed -i 's/^\s*\$ADMINUSER\s*=\s*'.*'\s*;\s*/\$ADMINUSER = "superadmin";/g' /var/www/html/fop2/admin/config.php 
sed -i 's/^\s*\$ADMINPWD\s*=\s*'.*'\s*;\s*/\$ADMINPWD = "admin";/g' /var/www/html/fop2/admin/config.php 
sed -i 's/^\s*\$DBHOST\s*=\s*'.*'\s*;\s*/\$DBHOST="localhost";/g' /var/www/html/fop2/admin/config.php 
sed -i 's/^\s*\$DBUSER\s*=\s*'.*'\s*;\s*/\$DBUSER="fop2";/g' /var/www/html/fop2/admin/config.php

sed -i "s/\(DBPASS= *\)\(.*\)/\1'$FOP2_DB_PW';/" /var/www/html/fop2/admin/config.php 

#CUSTOM dir fop2
ln -s /var/www/html/fop2 /var/www/html/panel
rm -fr /usr/src/fop2*
}

__mysql_config
__start_mysql
__install_fop2
__configure_fop2
