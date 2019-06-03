#!/usr/bin/env bash

set -e -x

export INFLUX_IP="192.168.11.20"
export DEBIAN_FRONTEND=noninteractive

# Update OS
apt-get -y -q update
apt-get -y -q -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt-get -y -q install openjdk-8-jdk-headless zsh

# Add Influx
wget -q https://dl.influxdata.com/influxdb/releases/influxdb_1.5.2_amd64.deb
dpkg -i influxdb_1.5.2_amd64.deb

# Configure Influx
cat <<EOF >> /etc/influxdb/influxdb.conf
[[graphite]]
  enabled = true
  database = "cassandra_metrics"

  retention-policy = ""
  bind-address = ":2003"
  protocol = "tcp"
  consistency-level = "one"
EOF

service influxdb start

# Wait for InfluxDB to start

while ! nc -z localhost 8086; do   
  sleep 0.1 
done

influx --execute 'CREATE DATABASE cassandra_metrics'
