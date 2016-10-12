#!/usr/bin/env bash
curl -sSL https://get.docker.com/gpg | sudo apt-key add -
curl -sSL https://get.docker.com/ | sh
sudo sh -c "curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
usermod -aG docker vagrant
usermod -aG docker www-data
