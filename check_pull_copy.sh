#!/bin/bash

cd /home/oif/OIF-Dashboard-Site \
&& git fetch origin \
&& git merge -s recursive -X theirs origin \
&& bundle exec jekyll build -d /var/www/OIF-Dashboard-Site \
&& cd ~
