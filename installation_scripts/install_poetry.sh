# ! commented out because oif is not sudo
# install python prerequisites
# sudo apt-get install -y build-essential \
#     libssl-dev \
#     zlib1g-dev \
#     libbz2-dev \
#     libreadline-dev \
#     libsqlite3-dev \
#     wget \
#     curl \
#     llvm \
#     libncurses5-dev \
#     libncursesw5-dev \
#     xz-utils \
#     tk-dev \
#     libffi-dev \
#     liblzma-dev \
#     python-openssl \
#     git

# log in as oif
su oif

# change directory to $HOME
cd ~

# install pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
&& echo -e '\nexport PATH="/home/oif/.pyenv/bin:$PATH"\neval "$(pyenv init -)"\neval "$(pyenv virtualenv-init -)"' >> ~/.bashrc \
&& exec $SHELL \
&& pyenv update

# use pyenv to install python 3.8.7
pyenv install 3.8.7 \
&& pyenv local 3.8.7

# install poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python - \
&& source $HOME/.poetry/env

# create a poetry venv
poetry new notebooks \
&& cd notebooks/ \
&& poetry shell \
&& poetry add --dev ipykernel


sudo /home/oif/.cache/pypoetry/virtualenvs/notebooks-s_KsaCdr-py3.8/bin/python -m pip install pexpect
sudo /home/oif/.cache/pypoetry/virtualenvs/notebooks-s_KsaCdr-py3.8/bin/python -m pip install python-dateutil
sudo /home/oif/.cache/pypoetry/virtualenvs/notebooks-s_KsaCdr-py3.8/bin/python -m ipykernel install --prefix=/opt/jupyterhub/ --name 'python' --display-name "Python (poetry)"
