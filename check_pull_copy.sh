#!/bin/bash

cd /home/oif/OIF-Dashboard-Site \
&& /usr/bin/git fetch origin \
&& if /usr/bin/git diff-index --quiet HEAD -- 
    then
    logger "merging changes from remote" \ 
    && /usr/bin/git merge -s recursive -X theirs origin \
    logger "rebuilding site" \
    && bundle exec jekyll build -d /var/www/OIF-Dashboard-Site
    else
    logger "site already up-to-date"
fi \
&& cd ~
