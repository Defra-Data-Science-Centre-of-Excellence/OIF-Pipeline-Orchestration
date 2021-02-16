#!/bin/bash

echo "# Setting up the JupyterHub and JupyterLab in a virtual environment" \
echo "# Creating the virtual environment" \
&& sudo python3 -m venv /opt/jupyterhub/ \
echo "# Installing required packages" \
&& sudo /opt/jupyterhub/bin/python3 -m pip install wheel \
&& sudo /opt/jupyterhub/bin/python3 -m pip install jupyterhub jupyterlab \
&& sudo /opt/jupyterhub/bin/python3 -m pip install ipywidgets \
&& echo "# Installing Node.js with Apt Using a NodeSource PPA" \
&& cd ~ \
&& ccurl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - \
&& sudo apt install nodejs \
&& echo "# Installing configurable-http-proxy" \
&& sudo npm install -g configurable-http-proxy \
&& echo "# Creating the folder for the JupyterHub configuration and navigating to it" \
&& sudo mkdir -p /opt/jupyterhub/etc/jupyterhub/ \
&& cd /opt/jupyterhub/etc/jupyterhub/ \
&& echo "# Generating the default configuration file" \
&& sudo /opt/jupyterhub/bin/jupyterhub --generate-config \
&& echo "# Setting up the Systemd service" \
&& echo "# Creating the folder for the service file" \
&& sudo mkdir -p /opt/jupyterhub/etc/systemd \
&& echo "# Create service file" \
&& sudo touch /opt/jupyterhub/etc/systemd/jupyterhub.service \
&& echo "# Writing service unit definition to file" \
&& echo -e '[Unit]\nDescription=JupyterHub\nAfter=syslog.target network.target\n\n[Service]\nUser=root\nEnvironment="PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/jupyterhub/bin"\nExecStart=/opt/jupyterhub/bin/jupyterhub -f /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py\n\n[Install]\nWantedBy=multi-user.target' > /opt/jupyterhub/etc/systemd/jupyterhub.service \
&& echo "# Symlinking file into systemd’s directory" \
&& sudo ln -s /opt/jupyterhub/etc/systemd/jupyterhub.service /etc/systemd/system/jupyterhub.service \
&& echo "# Reloading systemd configuration files" \
&& sudo systemctl daemon-reload \
&& echo "# Enabling the service" \
&& sudo systemctl enable jupyterhub.service \
&& echo "# Starting the service" \
&& sudo systemctl start jupyterhub.service \
&& echo "# Checking the service is running" \
&& sudo systemctl status jupyterhub.service
