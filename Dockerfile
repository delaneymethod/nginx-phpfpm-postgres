FROM ubuntu:18.04

MAINTAINER Sean Delaney <hello@delaneymethod.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales && locale-gen en_GB.UTF-8

ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nginx postgresql postgresql-contrib jpegoptim optipng pngquant gifsicle sendmail htop curl wget zip unzip git jq fail2ban gettext-base software-properties-common supervisor sqlite3 && add-apt-repository -y ppa:ondrej/php && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y php7.3-bcmath php7.3-fpm php7.3-cli php7.3-common php7.3-gd php7.3-mysql php7.3-pgsql php7.3-sqlite php7.3-sqlite3 php7.3-imap php7.3-memcached php7.3-mbstring php7.3-imagick php7.3-xml php7.3-zip php7.3-curl php7.3-xdebug && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer && mkdir /run/php && apt-get remove -y --purge software-properties-common && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/

COPY default /etc/nginx/sites-available/default

COPY www.conf /etc/php/7.3/fpm/pool.d/www.conf

COPY php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf

COPY php.ini /etc/php/7.3/fpm/php.ini

COPY xdebug.ini /etc/php/7.3/mods-available/xdebug.ini

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY start-container /usr/local/bin/start-container

RUN chmod +x /usr/local/bin/start-container

ADD set-psql-password.sh /tmp/set-psql-password.sh

RUN /bin/sh /tmp/set-psql-password.sh

RUN sed -i "/^#listen_addresses/i listen_addresses='*'" /etc/postgresql/9.5/main/postgresql.conf

RUN sed -i "/^# DO NOT DISABLE\!/i # Allow access from any IP address" /etc/postgresql/9.5/main/pg_hba.conf

RUN sed -i "/^# DO NOT DISABLE\!/i host all all 0.0.0.0/0 md5\n\n\n" /etc/postgresql/9.5/main/pg_hba.conf

EXPOSE 80 5432

VOLUME ["/var/lib/postgresql/9.5/main"]

CMD ["start-container"]
