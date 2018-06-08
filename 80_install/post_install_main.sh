#!/bin/bash

set -x

date

pushd www

git clone --depth 1 https://git.tt-rss.org/fox/tt-rss.git ttrss

popd

chmod 755 ./start_web.sh

date
