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
These are TODO. At present, this cookbook will not actually install client
libraries, although it will soon.

As of now, the official client libraries are Ruby, Python, Javascript, and 
Node. By default, the Ruby client is installed. To install others simply do:

`node.default[:influxdb][:clients] = ['python']`

You can also install the CLI for InfluxDB via:

`node.default[:influxdb][:clients] = ['python', 'cli']`

## Author and License
Simple Finance <ops@simple.com>
Apache License, Version 2.0

