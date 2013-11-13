# InfluxDB
Chef cookbook to install and configure InfluxDB.

## Usage and Resources
The InfluxDB cookbook comes with a Vagrantfile. Test using `vagrant up`. Simply
running the `default` recipe should be sufficient. Real tests coming soon!

For rendering the config, set the parameter under `node[:influxdb][:config]`:

`default[:influxdb][:config]['MyParameter'] = 'val'`

This cookbook ships with three LWRPs for managing the install, users, and
databases:

### influxdb
This resource installs and configures InfluxDB based on `node[:influxdb][:config]`:

```ruby
influxdb 'main' do
  source node[:influxdb][:source]
  checksum node[:influxdb][:checksum]
  config node[:influxdb][:config]
  action :create
end
```

The checksum and config parameters are optional.

### influxdb\_database
Configures an InfluxDB database.

```ruby
influxdb_database 'my_db' do
  action :create
end
```

### influxdb\_user
Configures a user to interact with InfluxDB databases.

```ruby
influxdb_user 'user' do
  password 'changeme'
  databases ['my_db']
  action :create
end
```

## Client Libraries
Right now, this cookbook only supports the Ruby and CLI client libraries so as
not to add too many dependencies. That might change in the near future. By
default both flavors are disabled. Enable e.g. Ruby via:

`node.default[:influxdb][:client][:ruby][:enable] = true`

## Author and License
Simple Finance <ops@simple.com>

Apache License, Version 2.0

