#!/usr/bin/env bash

set -e

# Update OS, setup 
apt-get -y -q update
apt-get -y -q dist-upgrade

# Setup SBT repository
echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

# Install necessary packages
apt-get -y -q update
apt-get -y -q install --no-install-recommends openjdk-8-jdk-headless wget vim git sbt ubuntu-desktop virtualbox-guest-dkms virtualbox-guest-x11 virtualbox-guest-utils

# Create and configure user: cassandra
# NOTE: this is not a safe way to configure user, but it is a training VM.
useradd -m cassandra -s /usr/bin/bash
echo "cassandra:cassandra" | chpasswd
mkdir /home/cassandra/training

# Download and unpack Cassandra
cd /home/cassandra/training
wget --quiet "https://www-eu.apache.org/dist/cassandra/3.11.4/apache-cassandra-3.11.4-bin.tar.gz"
tar xzf apache-cassandra-*.tar.gz

# Download and unpack IntelliJ IDEA CE
wget --quiet https://download.jetbrains.com/idea/ideaIC-2019.1.3.tar.gz
tar xzf ideaIC-*.tar.gz

# Clone Semantive repositories used for training
git clone https://github.com/Semantive/cassandra-trainings-crud-template.git
git clone https://github.com/Semantive/cassandra-trainings-cluster.git
git clone https://github.com/Semantive/cassandra-trainings-scripts.git
git clone https://github.com/Semantive/cassandra-trainings-bad-model-example.git

# Fix ownership on cassandra home directory
chown cassandra:cassandra -R /home/cassandra

# Reboot the VM
reboot

