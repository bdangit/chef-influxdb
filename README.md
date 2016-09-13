# InfluxDB

[![wercker status](https://app.wercker.com/status/d0f175cb46e417cde7974f179e63084d/m "wercker status")](https://app.wercker.com/project/bykey/d0f175cb46e417cde7974f179e63084d)

Chef cookbook to install and configure InfluxDB.

## Usage
To install InfluxDB and place its configuration file, include the
`influxdb::default` recipe in your node's `run_list`. The `default` recipe
installs the necessary dependencies to use the custom resources defined in this
cookbook.

For rendering the config set the parameter under
`node['influxdb']['config']`

`default['influxdb']['config']['MyParameter'] = 'val'`

## Resources
The following gems are used by the custom resources and are installed by the
`default` recipe:

 - [InfluxDB gem](https://github.com/influxdb/influxdb-ruby)
 - [toml-rb](https://github.com/emancu/toml-rb)

This cookbook ships with five custom resources for managing the configuration
file, users, databases, cluster admins, and retention policies:

### influxdb_config
This resource writes a configuration file for InfluxDB based on the passed
configuration hash:

```ruby
influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
  action :create
end
```

This resource is used by the `default` recipe to place the configuration
defined in `node['influxdb']['config']`.

### influxdb\_database
Configures an InfluxDB database.

```ruby
influxdb_database 'my_db' do
  action :create
end
```

### influxdb\_install
This resource sets up or removes the appropriate repositories and installs/removes the appropriate packages

```ruby
influxdb_install 'influxdb' do
  arch_type 'amd64' # if undefined will auto detect
  include_repository true # default
  influxdb_key 'https://repos.influxdata.com/influxdb.key' # default
  action :install # default
end
```

```ruby
influxdb_install 'influxdb' do
  action :remove
end
```

### influxdb\_user
This resources configures a user to interact with InfluxDB databases.

```ruby
influxdb_user 'user' do
  password 'changeme'
  databases ['my_db']
  action :create
end
```

### influxdb\_admin
This resources configures a cluster admin to interact with InfluxDB.

```ruby
influxdb_admin 'admin' do
  password 'changeme'
  action :create
end
```

### influxdb\_retention\_policy
This resources configures a retention policy on a given database. The name
attribute is not used, the database and policy name provide the unique names
used by InfluxDB.

```ruby
influxdb_retention_policy "foodb default retention policy" do
  policy_name 'default'
  database 'foodb'
  duration '1w'
  replication 1
  action :create
end
```

### influxdb\_continuous\_query
This resources configures a continuous query on a given database.

```ruby
influxdb_continuous_query "test_continuous_query" do
  database 'foodb'
  query 'SELECT min(mouse) INTO min_mouse FROM zoo GROUP BY time(30m)'
  action :create
end
```

## Client Libraries
Right now, this cookbook only supports the Ruby and CLI client libraries so as
not to add too many dependencies. That might change in the near future. By
default both flavors are disabled. Enable e.g. Ruby via:

`node.default['influxdb']['client']['ruby']['enable'] = true`

Finally include the `influxdb::client` in your node's `run_list` to install the
clients.

## Tests

To run tests, install all dependencies with [bundler](http://bundler.io/):

    bundle install

Then to run tests:

    rake # Quick tests only (rubocop + minitest)
    rake test:complete # All tests (rubocop + minitest + kitchen)

## Release Steps

1. Run through Deploy step in Wercker
2. `cd ..;  knife supermarket share influxdb "Monitoring & Trending" -o .`

## License
This project is licensed under the MIT license

## Maintainers
Ben Dang <me@bdang.it>

E Camden Fisher <fish@fishnix.net>
