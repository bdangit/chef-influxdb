# recipes/cli_client.rb

# Installs the InfluxDB CLI client

include_recipe 'nodejs::default'

nodejs_npm 'influxdb-cli' do
  action :install
end
