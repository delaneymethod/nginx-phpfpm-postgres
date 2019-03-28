FROM ubuntu:16.04

MAINTAINER Sean Delaney <hello@delaneymethod.com>

RUN apt-get update && apt-get install -y locales && locale-gen en_GB.UTF-8

ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

RUN apt-get update && apt-get install -y nginx postgresql postgresql-contrib jpegoptim optipng pngquant gifsicle sendmail htop curl wget zip unzip git jq fail2ban gettext-base software-properties-common supervisor sqlite3 && add-apt-repository -y ppa:ondrej/php && apt-get update && apt-get install -y php7.2-bcmath php7.2-fpm php7.2-cli php7.2-common php7.2-gd php7.2-mysql php7.2-pgsql php7.2-sqlite php7.2-sqlite3 php7.2-imap php7.2-memcached php7.2-mbstring php7.2-imagick php7.2-xml php7.2-zip php7.2-curl php7.2-xdebug && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer && mkdir /run/php && apt-get remove -y --purge software-properties-common && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/

COPY default /etc/nginx/sites-available/default

COPY www.conf /etc/php/7.2/fpm/pool.d/www.conf

COPY php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf

COPY php.ini /etc/php/7.2/fpm/php.ini

COPY xdebug.ini /etc/php/7.2/mods-available/xdebug.ini
     
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY start-container /usr/local/bin/start-container

RUN chmod +x /usr/local/bin/start-container

CMD ["start-container"]
