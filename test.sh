#!/bin/bash
docker build -t python . 
sudo rm /tmp/python3*deb
docker run -v /tmp:/packages -i -t python
cp install.sh /tmp
docker run -v /tmp:/tmp -i -t ubuntu /tmp/install.sh
