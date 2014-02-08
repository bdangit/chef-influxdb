#!/usr/bin/env ruby

Vagrant.configure('2') do |config|
  
  config.vm.define :influx do |influx|
    influx.vm.hostname = 'influxdb'
    influx.vm.box = ENV['VAGRANT_BOX'] || 'opscode_ubuntu-12.04_provisionerless'
    influx.vm.box_url = ENV['VAGRANT_BOX_URL'] || "https://opscode-vm.s3.amazonaws.com/vagrant/#{config.vm.box}.box"
    influx.vm.network :forwarded_port, guest: 8083,  host: 8083
    influx.vm.network :forwarded_port, guest: 8086,  host: 8086
    influx.omnibus.chef_version = ENV['CHEF_VERSION'] || :latest
    influx.berkshelf.enabled = true
    influx.berkshelf.berksfile_path = "./Berksfile"

    influx.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ENV['COOKBOOKS_PATH'] || './cookbooks'
      chef.run_list = [
        'recipe[apt]',
        'recipe[influxdb::default]',
      ]
    end
  end
end

