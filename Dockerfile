FROM cloyne/php

VOLUME /var/www/owncloud/config
VOLUME /owncloud-data
VOLUME /var/log/redis
VOLUME /var/lib/redis

RUN apt-get update -q -q && \
 apt-get install adduser wget ca-certificates software-properties-common --yes --force-yes && \
 wget --no-verbose https://download.owncloud.org/download/repositories/stable/Ubuntu_14.04/Release.key -O Release.key && \
 apt-key add - < Release.key && \
 rm -f Release.key && \
 echo 'deb http://download.owncloud.org/download/repositories/stable/Ubuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list && \
 apt-get purge wget --yes --force-yes && \
 apt-get autoremove --yes --force-yes && \
 apt-get install language-pack-en-base --yes --force-yes && \
 LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && \
 apt-get update -q -q && \
 apt-get install php5-cgi php5-cli redis-server php5-redis --yes --force-yes && \
 apt-get install owncloud --no-install-recommends --yes --force-yes && \
 apt-get install libipc-sharedcache-perl libmcrypt-dev mcrypt libterm-readkey-perl libreoffice-writer curl php-net-ftp php5-gmp php5-imagick libav-tools php5-json --yes --force-yes && \
 chown -Rh root:root /var/www/owncloud && \
 mkdir -p /owncloud-data && \
 adduser fcgi-php redis

COPY ./etc /etc
COPY ./config /var/www/owncloud/config
# We use the following directory to restore the configuration when an empty volume is mounted over /var/www/owncloud/config.
COPY ./config /etc/service/php/config
COPY ./apps /var/www/owncloud/apps
