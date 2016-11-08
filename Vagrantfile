# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"
  config.ssh.forward_agent = true
  config.omnibus.chef_version = :latest

  config.vm.network :forwarded_port, guest: 3000, host: 3031

  config.vm.synced_folder "dev/", "/home/vagrant/dev"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
end
