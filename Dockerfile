FROM tozd/php:7.0

VOLUME /var/www/owncloud/config
VOLUME /owncloud-data
VOLUME /var/log/redis
VOLUME /var/lib/redis

RUN apt-get update -q -q && \
 apt-get install apt-transport-https ca-certificates curl --yes --force-yes && \
 apt-get install redis-server php-redis --yes --force-yes && \
 curl https://download.owncloud.org/download/repositories/9.1/Ubuntu_16.04/Release.key | apt-key add - && \
 echo 'deb http://download.owncloud.org/download/repositories/9.1/Ubuntu_16.04/ /' >> /etc/apt/sources.list.d/owncloud.list && \
 apt-get update -q -q && \
 apt-get install owncloud --no-install-recommends --yes --force-yes && \
 apt-get install libipc-sharedcache-perl libmcrypt-dev mcrypt libterm-readkey-perl libreoffice-writer curl php-net-ftp php7.0-gmp php-imagick libav-tools php7.0-json php7.0-zip php7.0-xml php7.0-curl php7.0-gd php7.0-mbstring --yes --force-yes && \
 for file in /etc/php/7.0/mods-available/*.ini; do phpenmod $(basename -s .ini "$file"); done && \
 chown -Rh root:root /var/www/owncloud && \
 mkdir -p /owncloud-data && \
 adduser fcgi-php redis && \
 rm -f /var/www/owncloud/.user.ini

COPY ./etc /etc
COPY ./config /var/www/owncloud/config
# We use the following directory to restore the configuration when an empty volume is mounted over /var/www/owncloud/config.
COPY ./config /etc/service/php/config
COPY ./apps /var/www/owncloud/apps
