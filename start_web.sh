#!/bin/bash

set -x

export TZ=JST-9

whereis php

export postgres_user=$(echo ${DATABASE_URL} | awk -F':' '{print $2}' | sed -e 's/\///g')
export postgres_password=$(echo ${DATABASE_URL} | grep -o '/.\+@' | grep -o ':.\+' | sed -e 's/://' | sed -e 's/@//')
export postgres_server=$(echo ${DATABASE_URL} | awk -F'@' '{print $2}' | awk -F':' '{print $1}')
export postgres_dbname=$(echo ${DATABASE_URL} | awk -F'/' '{print $NF}')

mkdir -m 777 -p /tmp/lock
mkdir -m 777 -p /tmp/cache/images
mkdir -m 777 -p /tmp/cache/upload
mkdir -m 777 -p /tmp/cache/export
mkdir -m 777 -p /tmp/cache/js
mkdir -m 777 -p /tmp/feed-icons

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

htpasswd -c -b .htpasswd ${BASIC_USER} ${BASIC_PASSWORD}

mkdir -p /tmp/usr/lib
mkdir -p /tmp/usr/modules

cp lib/libbrotlicommon.so.1 /tmp/usr/lib/
cp lib/libbrotlienc.so.1 /tmp/usr/lib/
cp lib/mod_brotli.so /tmp/usr/modules/

export LD_LIBRARY_PATH=/tmp/usr/lib

vendor/bin/heroku-php-apache2 -C apache.conf www
