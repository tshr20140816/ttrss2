#!/bin/bash

set -x

date

pushd www

git clone --depth 1 https://github.com/phppgadmin/phppgadmin.git phppgadmin &

git clone --depth 1 -b 19.2 https://git.tt-rss.org/fox/tt-rss.git ttrss
cp ../config.php ttrss/

wait
cp ../config.inc.php phppgadmin/conf/
mv phppgadmin/include/functions.php phppgadmin/include/functions.php.org
cp ../functions.php phppgadmin/include/
diff phppgadmin/include/functions.php.org phppgadmin/include/functions.php
popd

chmod 755 ./start_web.sh

date
