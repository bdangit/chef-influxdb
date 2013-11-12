# InfluxDB
Chef cookbook to install and configure InfluxDB.

## Usage
The InfluxDB cookbook comes with a Vagrantfile. Test using `vagrant up`. Simply
running the `default` recipe should be sufficient.

For rendering the config, you can either set in an attributes file:

`default[:influxdb][:config][:my_parameter] = 'x'`

Or alternatively, call `InfluxDB::Helpers.render_config(some_hash)`. By
default, `some_hash` is `node[:influxdb][:config]`.

## Client Libraries
Right now, this cookbook only supports the Ruby and CLI client libraries so as
not to add too many dependencies. That might change in the near future. By
default, the Ruby client is enabled, while the CLI client is disabled. To
enable a flavor of client, set:

`node.default[:influxdb][:client][:my_flavor][:enable] = true`

## Author and License
Simple Finance <ops@simple.com>

Apache License, Version 2.0

