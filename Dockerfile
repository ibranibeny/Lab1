FROM debian
  
# Install.
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -q -y php && \
  apt-get install -y nginx php-fpm php-cgi php-cli   && \
#  apt-get install -y php-common php-mbstring php-xmlrpc php-soap php-xml php-intl php-curl libpq-dev  && \
  apt-get install -y net-tools unzip vim wget
RUN apt-get install -y --no-install-recommends --no-install-suggests supervisor cron glances



COPY index.php /var/www/html/
RUN chown www-data:www-data /var/www
RUN chown -R www-data:www-data /var/www/*
RUN chmod 755 -R /var/www/*

RUN mkdir -p /run/php
COPY nginx.conf /etc/nginx/nginx.conf
COPY php.ini /etc/php/7.3/fpm/php.ini
COPY default /etc/nginx/sites-enabled/default
CMD chown www-data:www-data /var/www
CMD chown -R www-data:www-data /var/www/*
RUN phpenmod opcache
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

CMD ["/usr/bin/supervisord"]
RUN rm -rf /var/www/html/www.conf
RUN rm -rf /var/www/html/Dockerfile
RUN rm -rf /var/www/html/default
RUN rm -rf /var/www/html/php.ini
RUN rm -rf /var/www/html/start_nginx.sh
RUN rm -rf /var/www/html/www.conf
RUN rm -rf /var/www/html/supervisor.conf
RUN rm -rf /var/www/html/nginx.conf
