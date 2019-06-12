#!/usr/bin/env bash

set -e -x

export INFLUX_IP="192.168.11.20"
export DEBIAN_FRONTEND=noninteractive

echo "deb https://packagecloud.io/grafana/stable/debian/ stretch main" > /etc/apt/sources.list.d/grafana.list
curl -s https://packagecloud.io/gpg.key | apt-key add -
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40F370A1F9081B64

# Update OS
apt-get -y -q update
apt-get -y -q -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt-get -y -q install grafana zsh

systemctl start grafana-server
