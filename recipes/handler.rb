# recipes/handler.rb

# Installs the ChefInfluxDB report handler
include_recipe 'chef_handler::default'

chef_gem 'chef-handler-influxdb' do
  version node['influxdb']['handler']['version']
  action :nothing
end.run_action(:install)

# Since arguments are required for this Chef handler, you can do the following
# in another cookbook to ensure this works :
# resources('chef_handler[ChefInfluxDB]').arguments[
#   :database => 'test',
#   :series => 'mine'
# ]
chef_handler 'ChefInfluxDB' do
  source ::File.join(Gem::Specification.find_by_name('chef-handler-influxdb').lib_dirs_glob,
                     'chef-handler-influxdb.rb')
  action :nothing
end.run_action(:enable)
