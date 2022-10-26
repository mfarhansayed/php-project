FROM php:7.0-apache

COPY . /var/www/html

EXPOSE 80
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]