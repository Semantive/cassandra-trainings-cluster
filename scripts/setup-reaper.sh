#!/usr/bin/env bash

set -e -x

export INFLUX_IP="192.168.11.20"
export DEBIAN_FRONTEND=noninteractive

echo "deb https://dl.bintray.com/thelastpickle/reaper-deb wheezy main" > /etc/apt/sources.list.d/reaper.list

# Update OS
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2895100917357435
apt-get -y -q update
apt-get -y -q -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt-get -y -q install openjdk-8-jdk-headless zsh
apt-get -y -q install reaper

# Setup hosts
echo "192.168.11.17 cassandra-1" >> /etc/hosts
echo "192.168.11.18 cassandra-2" >> /etc/hosts

sed -ir "s/Xmx2G/Xmx450M/" /usr/local/bin/cassandra-reaper 
sed -ir "s/Xms2G/Xms450M/" /usr/local/bin/cassandra-reaper 

service cassandra-reaper start