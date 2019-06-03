Vagrant.configure("2") do |config|

  config.vm.define "influxdb" do |influxdb|
    influxdb.vm.box = "ubuntu/xenial64"
    influxdb.vm.hostname = "influxdb"
    influxdb.vm.network "private_network", ip:"192.168.11.20"

    influxdb.vm.provider "virtualbox" do |vb|
      vb.name = "influxdb"
      vb.memory = 512
    end

    influxdb.vm.provision "shell" do |shell|
      shell.path  = "scripts/setup-influxdb.sh"
    end
  end

  config.vm.define "cassandra-1" do |cnode1|
    cnode1.vm.box = "ubuntu/xenial64"
    cnode1.vm.hostname = "cassandra-1"
    cnode1.vm.network "private_network", ip:"192.168.11.17"

    cnode1.vm.provider "virtualbox" do |vb|
      vb.name = "cassandra-1"
      vb.memory = 1024
    end

    cnode1.vm.provision "file", source: "assets/cassandra-env.sh", destination: "/tmp/cassandra-env.sh"
    cnode1.vm.provision "file", source: "assets/influx-reporting.yaml", destination: "/tmp/influx-reporting.yaml"

    cnode1.vm.provision "shell" do |shell|
      shell.path  = "scripts/setup-cassandra.sh"
      shell.args  = ["192.168.11.17"]
    end    
  end

  config.vm.define "cassandra-2" do |cnode2|
    cnode2.vm.box = "ubuntu/xenial64"
    cnode2.vm.hostname = "cassandra-2"
    cnode2.vm.network "private_network", ip:"192.168.11.18"

    cnode2.vm.provider "virtualbox" do |vb|
      vb.name   = "cassandra-2"
      vb.memory = 1024
    end
    
    cnode2.vm.provision "file", source: "assets/cassandra-env.sh", destination: "/tmp/cassandra-env.sh"
    cnode2.vm.provision "file", source: "assets/influx-reporting.yaml", destination: "/tmp/influx-reporting.yaml"

    cnode2.vm.provision "shell" do |shell|
      shell.path  = "scripts/setup-cassandra.sh"
      shell.args  = ["192.168.11.18"]
    end
  end

  config.vm.define "grafana" do |grafana|
    grafana.vm.box = "ubuntu/xenial64"
    grafana.vm.hostname = "grafana"
    grafana.vm.network "private_network", ip:"192.168.11.21"

    grafana.vm.provider "virtualbox" do |vb|
      vb.name = "grafana"
      vb.memory = 256
    end

    grafana.vm.provision "shell" do |shell|
      shell.path  = "scripts/setup-grafana.sh"
    end
  end

  config.vm.define "reaper" do |reaper|
    reaper.vm.box = "ubuntu/xenial64"
    reaper.vm.hostname = "reaper"
    reaper.vm.network "private_network", ip:"192.168.11.22"

    reaper.vm.provider "virtualbox" do |vb|
      vb.name = "reaper"
      vb.memory = 512
    end

    reaper.vm.provision "shell" do |shell|
      shell.path  = "scripts/setup-reaper.sh"
    end
  end

end