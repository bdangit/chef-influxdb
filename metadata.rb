# metadata.rb

name             'influxdb'
maintainer       'Ben Dang'
maintainer_email 'me@bdang.it'
license          'MIT'
description      'InfluxDB, a timeseries database'
version          '6.3.1'

supports 'centos'
supports 'debian'
supports 'redhat'
supports 'ubuntu'

# For CLI client
# https://github.com/redguide/nodejs
depends 'nodejs', '>= 2.4.4'

# For ChefInfluxDB Chef handler
# https://github.com/jakedavis/chef-handler-influxdb
depends 'chef_handler'

chef_version '>= 12.5' if respond_to?(:chef_version)
source_url 'https://github.com/bdangit/chef-influxdb' if respond_to?(:source_url)
issues_url 'https://github.com/bdangit/chef-influxdb/issues' if respond_to?(:issues_url)
