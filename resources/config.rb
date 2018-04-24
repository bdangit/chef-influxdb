# resources/config.rb

# Resource for building influxdb config file

property :path, String, name_property: true
property :config, Hash, required: true

default_action :create

include InfluxdbCookbook::Helpers

action :create do
  require 'toml'

  file new_resource.path do
    content TOML::Generator.new(new_resource.config).body
  end
end

action :delete do
  file new_resource.path do
    action :delete
  end
end
