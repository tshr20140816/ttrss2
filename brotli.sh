#!/bin/bash

set -x

ls www/ttrss/css/*.css

brotli -q 11 www/ttrss/css/default.css

ls -lang www/ttrss/css/
