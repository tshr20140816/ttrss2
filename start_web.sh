#!/bin/bash

set -x

export TZ=JST-9

whereis php

export postgres_user=$(echo ${DATABASE_URL} | awk -F':' '{print $2}' | sed -e 's/\///g')
export postgres_password=$(echo ${DATABASE_URL} | grep -o '/.\+@' | grep -o ':.\+' | sed -e 's/://' | sed -e 's/@//')
export postgres_server=$(echo ${DATABASE_URL} | awk -F'@' '{print $2}' | awk -F':' '{print $1}')
export postgres_dbname=$(echo ${DATABASE_URL} | awk -F'/' '{print $NF}')

cp config.php www/ttrss/

vendor/bin/heroku-php-apache2 -C apache.conf www
