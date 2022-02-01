# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "dev" do |dev|
    dev.vm.box = "debian/bullseye64"
    dev.vm.hostname = "dev"
    dev.vm.provider "virtualbox" do |provider|
      provider.name = "dev"
      provider.memory = 2048
      provider.cpus = 2
    end
    dev.vm.network :private_network, ip: "192.168.100.10"
    # Allow SSH connection using password
    dev.vm.provision "shell", inline: <<-SHELL
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
      service ssh restart
    SHELL
    dev.vm.provision "shell", path: "setup_env.sh", privileged: false
  end
end
