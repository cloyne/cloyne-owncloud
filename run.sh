#!/bin/bash -e

# An example script to run OwnCloud in production. It uses data volumes under the $DATA_ROOT directory.
# By default /srv. It uses a PostgreSQL database. The first time you have to create a database itself
# and account with permissions over it. Adding apps through the admin interface is disabled for security
# reasons.
#
# You have to create production config files. See below which one is mounted as a volume into a container.
# To create it, copy the sample over from the repository and modify it.

NAME='owncloud'
DATA_ROOT='/srv'
OWNCLOUD_CONFIG="${DATA_ROOT}/${NAME}/config"
OWNCLOUD_DATA="${DATA_ROOT}/${NAME}/data"
OWNCLOUD_LOG="${DATA_ROOT}/${NAME}/log"

mkdir -p "${OWNCLOUD_CONFIG}"
mkdir -p "${OWNCLOUD_DATA}"
mkdir -p "${OWNCLOUD_LOG}"

# If you are running the PostgreSQL image for the first time with its data volume, you should configure the
# database. Exec into the Docker container and run the following example commands to create user "owncloud"
# with database "owncloud", by default:
#
# docker exec -t -i pgsql /bin/bash
#
# createuser -U postgres -DRS -PE owncloud
# createdb -U postgres -O owncloud owncloud

docker stop "${NAME}" || true
sleep 1
docker rm "${NAME}" || true
sleep 1
docker run --detach=true --restart=always --name "${NAME}" --hostname "${NAME}" --expose 80 --publish 10.20.32.11:80:80/tcp --env PHP_FCGI_CHILDREN=30 --env ADMINADDR=root@cloyne.org --env REMOTES=mail.cloyne.net --volume "${OWNCLOUD_CONFIG}:/var/www/owncloud/config" --volume "${OWNCLOUD_DATA}:/owncloud-data" --volume "${OWNCLOUD_LOG}:/var/log/nginx" cloyne/owncloud

# When running it for the first time, you have to configure the instance. Open OwnCloud in the browser and
# choose PostgreSQL database and configure username and password. For data volume, specify "/owncloud-data".
# In OwnCloud admin interface also select system cron for cron type. Moreover, configure mail server. Despite
# PostgreSQL being configured, a "owncloud.db" file be created in the data directory. Feel free to delete it.
# Also configure the timezone ("logtimezone") in the config file. You might see a security warning that
# .htaccess file is not working and that files are accessible from the Internet. That is not true and is
# probably caused by a dangling "htaccesstest.txt" file in your data directory. Remove it and try again.
