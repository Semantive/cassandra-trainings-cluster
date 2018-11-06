#!/usr/bin/env bash

set -e -x

export INFLUX_IP="192.168.11.20"
export DEBIAN_FRONTEND=noninteractive

echo "deb https://packagecloud.io/grafana/stable/debian/ stretch main" > /etc/apt/sources.list.d/grafana.list
curl -s https://packagecloud.io/gpg.key | apt-key add -

# Update OS
apt-get -y -q update
apt-get -y -q -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt-get -y -q install grafana zsh

systemctl start grafana-server
