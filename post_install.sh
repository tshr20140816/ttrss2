#!/bin/bash

set -x

date

pushd www

git clone --depth=1 -b REL_7-12-0 https://github.com/phppgadmin/phppgadmin.git phppgadmin
# git clone --depth 1 -b 19.8 https://git.tt-rss.org/fox/tt-rss.git ttrss
git clone --depth=1 -b master https://github.com/tshr20140816/tt-rss.git ttrss
cp ../config.php ttrss/

cp ../config.inc.php phppgadmin/conf/
mv ttrss/include/functions.php ttrss/include/functions.php.org
# cp ../functions.php ttrss/include/
cp ../functions.19.8.php ttrss/include/functions.php
diff ttrss/include/functions.php.org ttrss/include/functions.php

popd

touch -t 0101010000 www/black.ico

time ls www/ttrss/css/*.css | xargs -n 1 brotli -Z
time ls www/ttrss/themes/*.css | xargs -n 1 brotli -Z

time ls www/ttrss/js/*.js | xargs -n 1 brotli -Z
time ls www/ttrss/js/form/*.js | xargs -n 1 brotli -Z

chmod 755 ./start_web.sh

date
