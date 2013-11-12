#!/usr/bin/env ruby

Vagrant.configure('2') do |config|
  
  config.vm.define :influx do |influx|
    influx.vm.hostname = 'influxdb'
    influx.vm.box = ENV['VAGRANT_BOX'] || 'opscode_ubuntu-12.04_provisionerless'
    influx.vm.box_url = ENV['VAGRANT_BOX_URL'] || "https://opscode-vm.s3.amazonaws.com/vagrant/#{config.vm.box}.box"
    influx.vm.network :forwarded_port, guest: 8083,  host: 8083
    influx.vm.network :forwarded_port, guest: 8086,  host: 8086
    influx.omnibus.chef_version = ENV['CHEF_VERSION'] || :latest

    influx.vm.provision :shell do |shell|
      shell.inline = 'test -f $1 || (sudo apt-get update -y && touch $1)'
      shell.args = '/var/run/apt-get-update'
    end

    influx.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = './cookbooks'
      chef.run_list = [
        'recipe[influxdb::default]',
      ]
    end
  end
end

