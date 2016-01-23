# recipes/client.rb

# Installs InfluxDB client libraries

%w(cli ruby).each do |flavor|
  next unless begin
                 node['influxdb']['client'][flavor]['enable']
               rescue
                 nil
               end

  include_recipe "influxdb::#{flavor}_client"
end
