#!/bin/sh

APACHE_SERVER_HOST=galaxy-docker.fedcloud-tf.fedcloud.eu

# Restart the shid service
/etc/init.d/shibd restart

# Restart the Apache2 service
/usr/sbin/apache2 -D FOREGROUND

# Enable the automatic renew of the Apache certificate
#/usr/bin/certbot renew --quiet
/usr/bin/certbot certonly --standalone -d ${APACHE_SERVER_HOST}
