#!/bin/bash

cd /home/oif/OIF-Dashboard-Site;

git fetch;

LOCAL=$(git rev-parse @);
REMOTE=$(git rev-parse @{u});

if [[ $LOCAL != $REMOTE ]]; then
    git reset --hard @{u} \
    && logger "reset local repo to match remote" \
    && /home/oif/.rbenv/shims/bundle exec jekyll build -d /var/www/OIF-Dashboard-Site/ \
    && logger "rebuilt site";
else
    logger "site already up-to-date";
fi

cd ~;
