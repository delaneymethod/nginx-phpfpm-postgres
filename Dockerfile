FROM ubuntu:21.04

MAINTAINER Sean Delaney <hello@delaneymethod.com>

RUN apt-get update && apt-get install -y locales && locale-gen en_GB.UTF-8

ENV TZ Europe/London
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y nano nginx postgresql-13 postgresql-client-13 postgresql-contrib-13 jpegoptim optipng pngquant gifsicle sendmail htop curl wget zip unzip git jq fail2ban gettext-base software-properties-common supervisor sqlite3 && add-apt-repository -y ppa:ondrej/php && apt-get update && apt-get install -y php7.4-bcmath php7.4-fpm php7.4-cli php7.4-common php7.4-gd php7.4-mysql php7.4-pgsql php7.4-sqlite php7.4-sqlite3 php7.4-imap php7.4-memcached php7.4-mbstring php7.4-imagick php7.4-xml php7.4-zip php7.4-curl php7.4-xdebug && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer && mkdir /run/php && apt-get remove -y --purge software-properties-common && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/

COPY default /etc/nginx/sites-available/default

COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

COPY php.ini /etc/php/7.4/fpm/php.ini

COPY xdebug.ini /etc/php/7.4/mods-available/xdebug.ini

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY postgresql.conf /etc/postgresql/13/main/postgresql.conf

COPY pg_hba.conf /etc/postgresql/13/main/pg_hba.conf

RUN mkdir -p /var/run/postgresql/13-main.pg_stat_tmp

RUN chown -R postgres.postgres /var/run/postgresql/13-main.pg_stat_tmp

COPY start-container /usr/local/bin/start-container

RUN chmod +x /usr/local/bin/start-container

COPY postgresql-setpassword.sh /usr/local/bin/postgresql-setpassword.sh

RUN chmod +x /usr/local/bin/postgresql-setpassword.sh

RUN /bin/sh /usr/local/bin/postgresql-setpassword.sh

CMD ["start-container"]
