# resources/config.rb

# Resource for building influxdb config file

property :path, String, name_property: true
property :config, Hash, required: true

default_action :create

action :create do
  require 'toml-rb'

  file path do
    content TomlRB.dump(config)
  end
end

action :delete do
  file path do
    action :delete
  end
end
