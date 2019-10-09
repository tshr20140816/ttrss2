#!/bin/bash

set -x

date

# ***** phppgadmin *****

git clone --depth=1 -b REL_7-12-0 https://github.com/phppgadmin/phppgadmin.git www/phppgadmin 2>/dev/null

mv ./config.inc.php www/phppgadmin/conf/

# ***** ttrss ******

# git clone --depth 1 -b 19.8 https://git.tt-rss.org/fox/tt-rss.git www/ttrss
git clone --depth=1 -b master https://github.com/tshr20140816/tt-rss.git www/ttrss

mv ./config.php www/ttrss/
mv www/ttrss/include/functions.php www/ttrss/include/functions.php.org

mv ./functions.19.8.php www/ttrss/include/functions.php
diff www/ttrss/include/functions.php.org www/ttrss/include/functions.php

brotli -Z www/black.ico
touch -t 0101010000 www/black.ico
touch -t 0101010000 www/black.ico.br

time ls www/ttrss/css/*.css | xargs -n 1 brotli -Z
time ls www/ttrss/themes/*.css | xargs -n 1 brotli -Z

time ls www/ttrss/js/*.js | xargs -n 1 brotli -Z
time ls www/ttrss/js/form/*.js | xargs -n 1 brotli -Z

# ***** etc *****

chmod 755 ./start_web.sh

date
