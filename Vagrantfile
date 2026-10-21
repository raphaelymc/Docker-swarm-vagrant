 Vagrant.configure("2") do |config|

  config.vm.provision "shell", path: "install-docker.sh"

  config.vm.define "master" do |master|
    master.vm.box = "bento/ubuntu-22.04"
    master.vm.hostname = "master"

    master.vm.network "private_network", ip: "192.168.56.10"

    master.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1

    end

    master.vm.provision "shell", path: "init-swarm.sh"

  end


# Worker 01
  config.vm.define "node01" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "node01"
    node.vm.network "private_network", ip: "192.168.56.11"

    node.vm.provider "virtualbox" do |vb|
      vb.memory = 768
      vb.cpus = 1
    end

    node.vm.provision "shell", path: "join-swarm.sh"
 
 end

  # Worker 02
  config.vm.define "node02" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "node02"
    node.vm.network "private_network", ip: "192.168.56.12"

    node.vm.provider "virtualbox" do |vb|
      vb.memory = 768
      vb.cpus = 1
    end

    node.vm.provision "shell", path: "join-swarm.sh"
 
 end

  # Worker 03
  config.vm.define "node03" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "node03"
    node.vm.network "private_network", ip: "192.168.56.13"

    node.vm.provider "virtualbox" do |vb|
      vb.memory = 768
      vb.cpus = 1
    end 

    node.vm.provision "shell", path: "join-swarm.sh"

end

end
