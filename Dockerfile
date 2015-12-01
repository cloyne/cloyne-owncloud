FROM cloyne/php

RUN apt-get update -q -q && \
 apt-get install wget ca-certificates software-properties-common --yes --force-yes && \
 wget --no-verbose https://download.owncloud.org/download/repositories/stable/Ubuntu_14.04/Release.key -O Release.key && \
 apt-key add - < Release.key && \
 rm -f Release.key && \
 echo 'deb http://download.owncloud.org/download/repositories/stable/Ubuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list && \
 apt-get purge wget --yes --force-yes && \
 apt-get autoremove --yes --force-yes && \
 add-apt-repository ppa:ondrej/php5-5.6 && \
 apt-get update -q -q && \
 apt-get install php5-cgi php5-cli --yes --force-yes && \
 apt-get install owncloud --no-install-recommends --yes --force-yes && \
 apt-get install libipc-sharedcache-perl libmcrypt-dev mcrypt libterm-readkey-perl libreoffice-writer curl php-net-ftp php5-gmp php5-imagick libav-tools php5-json --yes --force-yes && \
 chown -Rh root:root /var/www/owncloud && \
 mkdir -p /owncloud-data

COPY ./etc /etc
COPY ./config /var/www/owncloud/config
COPY ./config /etc/service/php/config
COPY ./apps /var/www/owncloud/apps
