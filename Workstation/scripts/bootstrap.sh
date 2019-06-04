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
apt-get -y -q install --no-install-recommends openjdk-8-jdk-headless wget vim git sbt ubuntu-desktop virtualbox-guest-dkms virtualbox-guest-x11 virtualbox-guest-utils firefox libgtk2.0-0
# libgtk2.0-0 is necessary to run DevCenter

# Create and configure user: cassandra
# NOTE: this is not a safe way to configure user, but it is a training VM.
useradd -m cassandra -s /usr/bin/bash
echo "cassandra:cassandra" | chpasswd
mkdir /home/cassandra/training

mkdir -p /home/cassandra/.local/share/applications

# Unpack DevCenter
cd /home/cassandra/training
mv /tmp/devcenter.tar.gz ./devcenter.tar.gz
tar xzf devcenter.tar.gz

touch /home/cassandra/.local/share/applications/devcenter.desktop
cat <<EOF >/home/cassandra/.local/share/applications/devcenter.desktop
[Desktop Entry]
Name=Datastax DevCenter
Comment=
Exec=/home/cassandra/training/DevCenter/DevCenter
Icon=/home/cassandra/training/DevCenter/icon.xpm
Terminal=false
Type=Application
StartupNotify=true
EOF
chmod +x /home/cassandra/.local/share/applications/devcenter.desktop

# Download and unpack Cassandra
wget --quiet "https://www-eu.apache.org/dist/cassandra/3.11.4/apache-cassandra-3.11.4-bin.tar.gz"
tar xzf apache-cassandra-*.tar.gz

# Download and unpack IntelliJ IDEA CE
wget --quiet https://download.jetbrains.com/idea/ideaIC-2019.1.3.tar.gz
tar xzf ideaIC-*.tar.gz

touch /home/cassandra/.local/share/applications/intellij.desktop
cat <<EOF >/home/cassandra/.local/share/applications/intellij.desktop
[Desktop Entry]
Name=IntelliJ IDEA
Comment=
Exec=/home/cassandra/training/idea-IC-191.7479.19/bin/idea.sh
Icon=/home/cassandra/training/idea-IC-191.7479.19/bin/idea.png
Terminal=false
Type=Application
StartupNotify=true
EOF
chmod +x /home/cassandra/.local/share/applications/intellij.desktop

# Clone Semantive repositories used for training
git clone https://github.com/Semantive/cassandra-trainings-crud-template.git
git clone https://github.com/Semantive/cassandra-trainings-cluster.git
git clone https://github.com/Semantive/cassandra-trainings-scripts.git
git clone https://github.com/Semantive/cassandra-trainings-bad-model-example.git

# Fix ownership on cassandra home directory
chown cassandra:cassandra -R /home/cassandra

# Reboot the VM
reboot

