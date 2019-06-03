#!/usr/bin/env bash

set -e -x

export SEEDS="192.168.11.17,192.168.11.18"
export INFLUX_IP="192.168.11.20"
export DEBIAN_FRONTEND=noninteractive

export LOCAL_IP="$1"
export HOSTNAME=`hostname`
export ALL_IPS="$SEEDS"

echo "deb http://www.apache.org/dist/cassandra/debian 311x main" > /etc/apt/sources.list.d/cassandra.sources.list
curl -s https://www.apache.org/dist/cassandra/KEYS | apt-key add -

# Update OS
apt-get -y -q update
apt-get -y -q -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt-get -y -q install openjdk-8-jdk-headless collectd collectd-utils zsh cassandra

# Setup hosts
echo "192.168.11.17 cassandra-1" >> /etc/hosts
echo "192.168.11.18 cassandra-2" >> /etc/hosts

# Configure Cassandra
systemctl stop cassandra

# Allow auth-less JMX access
# Not suitable for production!
cp /tmp/cassandra-env.sh /etc/cassandra/cassandra-env.sh
sed -ir "s/{C_HOSTNAME}/$HOSTNAME/" /etc/cassandra/cassandra-env.sh
sed -ir "s/Test Cluster/Training Cluster/" /etc/cassandra/cassandra.yaml
sed -ir "s/seeds: \"127.0.0.1\"/seeds: \"${SEEDS}\"/" /etc/cassandra/cassandra.yaml
sed -ir "s/listen_address: localhost/listen_address: ${LOCAL_IP}/" /etc/cassandra/cassandra.yaml
sed -ir "s/rpc_address: localhost/rpc_address: ${LOCAL_IP}/" /etc/cassandra/cassandra.yaml

cp /tmp/influx-reporting.yaml /etc/cassandra/influx-reporting.yaml
sed -ir "s/{LOCAL_IP}/${LOCAL_IP}/" /etc/cassandra/influx-reporting.yaml
sed -ir "s/{INFLUX_IP}/${INFLUX_IP}/" /etc/cassandra/influx-reporting.yaml

# Setup Graphite logging
wget -q "https://maven.atlassian.com/maven-external/io/dropwizard/metrics/metrics-graphite/3.1.2/metrics-graphite-3.1.2.jar" -P /usr/share/cassandra/lib
chown cassandra:cassandra /etc/cassandra/influx-reporting.yaml /usr/share/cassandra/lib/metrics-graphite-3.1.2.jar

# Purge data files (required because of changing snitch)
rm -rf /var/lib/cassandra/*

cat <<EOF > /etc/collectd/collectd.conf
Hostname "${LOCAL_IP}"
FQDNLookup false

Interval 60

LoadPlugin cpu
LoadPlugin df
LoadPlugin memory
LoadPlugin write_graphite

<Plugin cpu>
        ReportByCpu true
        ReportByState true
        ValuesPercentage false
</Plugin>

<Plugin df>
        Device "/dev/nvme0n1p1"
        MountPoint "/"
        FSType "ext4"
</Plugin>

<Plugin memory>
        ValuesAbsolute true
        ValuesPercentage false
</Plugin>

<Plugin write_graphite>
        <Node "example">
                Host "${INFLUX_IP}"
                Port "2003"
                Protocol "tcp"
                LogSendErrors true
                Prefix "collectd."
                StoreRates true
                AlwaysAppendDS false
                EscapeCharacter "_"
        </Node>
</Plugin>
EOF

# Configure Cassandra
systemctl start cassandra