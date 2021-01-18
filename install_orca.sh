# Update package list and upgrade existing packages and dependencies
sudo apt-get update \
&& sudo apt-get dist-upgrade -y \
&& sudo apt-get autoremove -y \
&& sudo apt-get autoclean -y 

# Install additional system libraries
sudo apt-get install -y libgtk2.0-0 libgconf-2-4 xvfb

# Define variables
ORCA_VER="1.3.1"
URL="https://github.com/plotly/orca/releases/download/v${ORCA_VER}/orca-${ORCA_VER}.AppImage"
DOWNLOAD_PATH="$HOME/Downloads/orca-${ORCA_VER}.AppImage"
SCRIPT_PATH="$HOME/path/to/script/orca.sh" # Replace /path/to/script 

# Download Orca AppImage to DOWNLOAD_PATH and make executable
wget $URL -O $DOWNLOAD_PATH \
&& chmod +x $DOWNLOAD_PATH

# Create xvfb script and make executable
echo '#!/bin/bash' > $SCRIPT_PATH \
&& echo "xvfb-run -a ${DOWNLOAD_PATH} \"\$@\"" >> $SCRIPT_PATH \
&& chmod +x $SCRIPT_PATH

# Add symbolic link to xvfb script into PATH
sudo ln -sf $SCRIPT_PATH /usr/local/bin/orca

# Verify that link is working
which orca # This should return /usr/local/bin/orca

# Verify that orca is working
orca --version # This should return ORCA_VER