#!/bin/bash

set -x

date

pushd www

git clone --depth=1 -b REL_5-6-0 https://github.com/phppgadmin/phppgadmin.git phppgadmin
# git clone --depth 1 -b 19.8 https://git.tt-rss.org/fox/tt-rss.git ttrss
git clone --depth=1 -b master https://github.com/tshr20140816/tt-rss.git ttrss
cp ../config.php ttrss/

cp ../config.inc.php phppgadmin/conf/
mv ttrss/include/functions.php ttrss/include/functions.php.org
# cp ../functions.php ttrss/include/
cp ../functions.19.8.php ttrss/include/functions.php
diff ttrss/include/functions.php.org ttrss/include/functions.php
popd

chmod 755 ./start_web.sh

date
