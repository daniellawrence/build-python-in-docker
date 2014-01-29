#!/bin/bash
cd /tmp
dpkg -i python3-full-3.3.3_amd64.deb 
apt-get install -f -y
cd /usr/local/bin/
./pip3 freeze
./pip3 install flake8
./pip3 freeze
./pip3 install flask
./pip3 freeze
