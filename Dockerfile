# Download base image Ubuntu 16.04
FROM ubuntu:16.04

MAINTAINER Giuseppe La Rocca - EGI Foundation (version: 0.1)

# Define the environment variables
ENV APACHE_RUN_DIR /etc/apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_LOG_DIR /var/log/apache2
# Set here the Apache server hostname used to proxy the Galaxy container
ENV APACHE_SERVER_HOST galaxy-docker.fedcloud-tf.fedcloud.eu
# Set the server path where install trusted host certificate.
# Host certificates need to be requested in advance containg a trusted CA.
# E.g.: Let's Encrypt CA at: https://letsencrypt.org/
ENV APACHE_CERTS_PATH /etc/letsencrypt/live/${APACHE_SERVER_HOST}/
ENV SHIBBOLETH_PATH /etc/shibboleth

# Update Ubuntu Software repository and install missing dependencies
RUN apt-get update
RUN apt-get install -y vim curl software-properties-common
RUN apt-get install -y apache2
RUN apt-get install -y libapache2-mod-xsendfile
RUN apt-get install -y libapache2-mod-shib2

RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:certbot/certbot
RUN apt-get -y update
RUN apt-get install -y python-certbot-apache

# Configure Apache2 with missing modules
RUN a2enmod rewrite
RUN a2enmod shib2
RUN a2enmod headers
RUN a2enmod expires
RUN a2enmod ssl
RUN a2enmod proxy
RUN a2enmod proxy_http

# Change Apache settings
RUN chown -R www-data:www-data /var/www

# Activate the SSL Virtual Host
RUN a2dissite 000-default.conf
RUN a2ensite default-ssl.conf

# Configuring the container...
#
# 1.) Register the Apache2 server hostname in the DNS
# E.g.: Used the Dynamic DNS service for the EGI Federated Cloud
# More info available at: https://nsupdate.fedcloud.eu/
#CMD ["curl", "https://${APACHE_SEVER_HOST}:uanu99r4FV@nsupdate.fedcloud.eu/nic/update"]
CMD ["curl", "https://${APACHE_SEVER_HOST}:uMHxXvnhVB@nsupdate.fedcloud.eu/nic/update"]

# 2.) Install the Apache2 server host certificates
CMD ["mkdir", "-p", "${APACHE_CERTS_PATH}"]
CMD ["mkdir", "-p", "${SHIBBOLETH_PATH}/cert"]
COPY certs/cert.pem ${APACHE_CERTS_PATH}
COPY certs/privkey.pem ${APACHE_CERTS_PATH}
COPY certs/chain.pem ${APACHE_CERTS_PATH}

# 3.) Update configuration settings for Apache2
COPY apache-conf/default-ssl.conf ${APACHE_RUN_DIR}/sites-available/default-ssl.conf

# 4.) Install host certificates for Shibboleth
COPY certs/cert.pem ${SHIBBOLETH_PATH}/cert/sp.crt
COPY certs/privkey.pem ${SHIBBOLETH_PATH}/cert/sp.key

# 5.) Update configuration settings foe Shibboleth
COPY shibboleth-conf/attribute-map.xml ${SHIBBOLETH_PATH}
COPY shibboleth-conf/attribute-policy.xml ${SHIBBOLETH_PATH}
COPY shibboleth-conf/shibboleth2.xml ${SHIBBOLETH_PATH}

# Use a bash script to start Apache2 + Shibboleth services
COPY startup.sh /usr/local/
CMD ["/bin/bash", "/usr/local/startup.sh"]

EXPOSE 80 443
