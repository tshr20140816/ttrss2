#!/bin/bash

set -x

date

pushd www

# git clone --depth 1 https://git.tt-rss.org/fox/tt-rss.git ttrss
git clone --depth 1 -b 17.12 https://tt-rss.org/git/tt-rss.git /tmp/ttrss
cp ../config.php ttrss/

git clone --depth 1 https://github.com/phppgadmin/phppgadmin.git phppgadmin
cp ../config.inc.php phppgadmin/conf/
cp ../Connection.php phppgadmin/classes/database/

popd

chmod 755 ./start_web.sh

date
