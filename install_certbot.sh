#!/bin/bash

# check for snap
snap --version
if [ $? -eq 0 ]; then
    echo "# Ensuring that snap is up to date" \
    && sudo snap refresh core \
    && echo "# Removing certbot-auto and any Certbot OS packages" \
    && sudo apt-get remove -y certbot \
    && echo "# Installing Certbot" \
    && sudo snap install --classic certbot \
    && echo "# Preparing the Certbot command" \
    && sudo ln -sf /snap/bin/certbot /usr/bin/certbot \
    && echo "# Getting certificate and editing Nginx configuration" \
    && sudo certbot --nginx \
    && echo "# Testing automatic renewal" \
    && sudo certbot renew --dry-run
else
    echo "Snap not installed, installing snap" \
    && sudo snap install core \
    && echo "Snap installed, re-run certbot installation script"
fi
