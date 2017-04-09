FROM tozd/php:5.5

VOLUME /var/www/owncloud/config
VOLUME /owncloud-data
VOLUME /var/log/redis
VOLUME /var/lib/redis

RUN apt-get update -q -q && \
 apt-get install adduser ca-certificates software-properties-common curl --yes --force-yes && \
 curl https://download.owncloud.org/download/repositories/stable/Ubuntu_14.04/Release.key | apt-key add - && \
 echo 'deb http://download.owncloud.org/download/repositories/stable/Ubuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list && \
 apt-get install language-pack-en-base --yes --force-yes && \
 LC_ALL=en_US.UTF-8 add-apt-repository --yes ppa:ondrej/php && \
 apt-get update -q -q && \
 apt-get install php5.6-cgi php5.6-cli redis-server php-redis php5.6-pgsql --yes --force-yes && \
 apt-get install owncloud --no-install-recommends --yes --force-yes && \
 apt-get install libipc-sharedcache-perl libmcrypt-dev mcrypt libterm-readkey-perl libreoffice-writer curl php-net-ftp php5.6-gmp php-imagick libav-tools php5.6-json php5.6-zip php5.6-xml php5.6-curl php5.6-gd php5.6-mbstring --yes --force-yes && \
 chown -Rh root:root /var/www/owncloud && \
 mkdir -p /owncloud-data && \
 adduser fcgi-php redis && \
 rm -f /var/www/owncloud/.user.ini

COPY ./etc /etc
COPY ./config /var/www/owncloud/config
# We use the following directory to restore the configuration when an empty volume is mounted over /var/www/owncloud/config.
COPY ./config /etc/service/php/config
COPY ./apps /var/www/owncloud/apps
