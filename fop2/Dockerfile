FROM centos:centos7
MAINTAINER Federico Pereira <fpereira@cnsoluciones.com>

LABEL \
	name="fop2 Image" \
	image="fop2" \
	vendor="cnsoluciones" \
	license="MIT" \
	build-date="2018-04-22"

#ARG
ARG AMI_HOST
ARG AMI_PORT
ARG AMI_USER
ARG AMI_SECRET

ENV FOP2_AMI_HOST $AMI_HOST
ENV FOP2_AMI_PORT $AMI_PORT
ENV FOP2_AMI_USER $AMI_USER
ENV FOP2_AMI_SECRET $AMI_SECRET

# Update S.O.
RUN yum -y update

# Install varioius utilities
RUN yum -y install curl wget htop unzip git vim iproute hostname inotify-tools yum-utils which openssh-clients bind-utils net-tools psmisc make

# Install Python and Supervisor
RUN yum -y install epel-release \
&& yum clean all
RUN yum -y install supervisor

# Install Apache
RUN yum -y install httpd mod_ssl

# Reconfigure Apache
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf \
&& sed -i 's#DocumentRoot "/var/www/html"#DocumentRoot "/var/www/html/fop2"#' /etc/httpd/conf/httpd.conf \
&& chown root:apache /var/www/html \
&& chmod g+s /var/www/html

# Install PHP
RUN yum -y install php php-devel php-gd php-pdo php-soap php-xmlrpc php-xml php-mbstring php-mysqli

# Configure php.ini
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 512M/g' /etc/php.ini \
&& sed -i 's/post_max_size = 8M/post_max_size = 512M/g' /etc/php.ini \
&& sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php.ini

# Install MariaDB
COPY MariaDB.repo /etc/yum.repos.d/MariaDB.repo
RUN yum clean all \
&& yum -y install mariadb-server mariadb-client

# UTC Timezone & Networking
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
	&& echo "NETWORKING=yes" > /etc/sysconfig/network

ADD install.sh /tmp/install.sh
RUN chmod 755 /tmp/install.sh
RUN /tmp/install.sh

# Volume
VOLUME ["/etc/asterisk"]
COPY functions-custom.php /var/www/html/fop2/admin/functions-custom.php
RUN chmod 777 /var/www/html/fop2/admin/functions-custom.php
RUN chown apache:apache  /var/www/html/fop2/admin/functions-custom.php

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 80 443 4445
CMD ["/usr/bin/supervisord"]
