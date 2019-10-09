#!/bin/bash

set -x

ls www/ttrss/css/*.css | xargs -n 3 brotli -Z
ls www/ttrss/themes/*.css | xargs -n 3 brotli -Z

ls www/ttrss/js/*.js | xargs -n 3 brotli -Z
ls www/ttrss/js/form/*.js | xargs -n 3 brotli -Z
