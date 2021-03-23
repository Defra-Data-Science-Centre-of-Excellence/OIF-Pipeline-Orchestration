#!/bin/bash

cd /home/oif/OIF-Dashboard-Site;

git fetch;

LOCAL=$(git rev-parse @);
REMOTE=$(git rev-parse @{u});

if [[ $LOCAL != $REMOTE ]]; then
    git reset --hard @{u} \
    && logger "reset local repo to match remote";
else
    logger "site already up-to-date";
fi

cd ~;
