#!/bin/bash

set -x

export TZ=JST-9

whereis php

export postgres_user=$(echo ${DATABASE_URL} | awk -F':' '{print $2}' | sed -e 's/\///g')
export postgres_password=$(echo ${DATABASE_URL} | grep -o '/.\+@' | grep -o ':.\+' | sed -e 's/://' | sed -e 's/@//')
export postgres_server=$(echo ${DATABASE_URL} | awk -F'@' '{print $2}' | awk -F':' '{print $1}')
export postgres_dbname=$(echo ${DATABASE_URL} | awk -F'/' '{print $NF}')

cp config.php www/ttrss/

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

htpasswd -c -b .htpasswd ${BASIC_USER} ${BASIC_PASSWORD}

vendor/bin/heroku-php-apache2 -C apache.conf www
