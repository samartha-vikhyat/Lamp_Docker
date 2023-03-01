FROM php:7.4-apache

# Added some MySQL support tools inside the PHP container for the two services (db and php-apache) to work correctly.
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli && docker-php-ext-install pdo pdo_mysql

# Added this commands to enable SSL:
RUN a2enmod rewrite && a2enmod ssl && a2enmod socache_shmcb

# modify /etc/apache2/sites-available/default-ssl.conf to look like
#
# SSLCertificateFile      /etc/ssl/certs/mycert.crt
# SSLCertificateKeyFile /etc/ssl/private/mycert.key

RUN sed -i '/SSLCertificateFile.*snakeoil\.pem/c\SSLCertificateFile \/etc\/ssl\/certs\/mycert.crt' /etc/apache2/sites-available/default-ssl.conf && sed -i '/SSLCertificateKeyFile.*snakeoil\.key/cSSLCertificateKeyFile /etc/ssl/private/mycert.key\' /etc/apache2/sites-available/default-ssl.conf

# To enable the SSL-enabled site with a2ensite default-ssl 
RUN a2ensite default-ssl

RUN apt-get update && apt-get upgrade -y

# More details on https://forums.docker.com/t/setup-local-domain-and-ssl-for-php-apache-container/116015
