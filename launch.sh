#!/bin/bash

apt-get update
apt-get install -y python-pip wget

wget -qO- https://get.docker.com/ | sh

./logstash-conf.py > logstash-conf/logstash.conf

pip install docker-compose

docker-compose up
