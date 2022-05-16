# resources/config.rb

# Resource for building influxdb config file

property :path, String, name_property: true
property :config, Hash, required: true

default_action :create

action :create do
  if Version.new(Chef::VERSION) >= Version.new('17.3.48')
    content = render_toml(new_resource.config)
  else
    require 'toml'

    content = TOML::Generator.new(new_resource.config).body
  end

  file new_resource.path do
    content content
  end
end

action :delete do
  file new_resource.path do
    action :delete
  end
end
