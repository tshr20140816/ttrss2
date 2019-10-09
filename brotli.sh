#!/bin/bash

set -x

ls www/ttrss/css/*.css

brotli -q 11 www/ttrss/css/default.css

ls -lang www/ttrss/css/

ls www/ttrss/js/*.js | xargs -n 3 brotli -k -z

ls -lang www/ttrss/js/
