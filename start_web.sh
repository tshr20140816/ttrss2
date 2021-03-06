#!/bin/bash

set -x

export TZ=JST-9

export postgres_user=$(echo ${DATABASE_URL} | awk -F':' '{print $2}' | sed -e 's/\///g')
export postgres_password=$(echo ${DATABASE_URL} | grep -o '/.\+@' | grep -o ':.\+' | sed -e 's/://' | sed -e 's/@//')
export postgres_server=$(echo ${DATABASE_URL} | awk -F'@' '{print $2}' | awk -F':' '{print $1}')
export postgres_dbname=$(echo ${DATABASE_URL} | awk -F'/' '{print $NF}')

mkdir -m 777 -p /tmp/lock
mkdir -m 777 -p /tmp/cache/images
mkdir -m 777 -p /tmp/cache/upload
mkdir -m 777 -p /tmp/cache/export
mkdir -m 777 -p /tmp/cache/js
mkdir -m 777 -p www/ttrss/feed-icons

cp www/*.ico www/ttrss/feed-icons/

pushd www/ttrss/feed-icons
seq 1 99 | xargs -L 1 -P 7 -I{} ln -s dot.ico {}.ico &
popd

if [ ! -v BASIC_USER ]; then
  echo "Error : BASIC_USER not defined."
  exit
fi

if [ ! -v BASIC_PASSWORD ]; then
  echo "Error : BASIC_PASSWORD not defined."
  exit
fi

export HOME_IP_ADDRESS=$(nslookup ${HOME_FQDN} 8.8.8.8 | tail -n2 | grep -o '[0-9]\+.\+')
if [ -z "${HOME_IP_ADDRESS}" ]; then
  HOME_IP_ADDRESS=127.0.0.1
fi

# if [ -v LOGGLY_TOKEN ]; then
#     url="https://logs-01.loggly.com/inputs/${LOGGLY_TOKEN}/tag/${HEROKU_APP_NAME}"
#     curl -H "content-type:text/plain" -d "${HEROKU_APP_NAME} START" ${url}
# fi

htpasswd -c -b .htpasswd ${BASIC_USER} ${BASIC_PASSWORD}

mkdir -p /tmp/usr/lib

cp lib/libbrotlicommon.so.1 /tmp/usr/lib/
cp lib/libbrotlienc.so.1 /tmp/usr/lib/

export LD_LIBRARY_PATH=/tmp/usr/lib

vendor/bin/heroku-php-apache2 -C apache.conf www
