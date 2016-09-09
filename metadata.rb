# metadata.rb

name             'influxdb'
maintainer       'Ben Dang'
maintainer_email 'me@bdang.it'
license          'MIT'
description      'InfluxDB, a timeseries database'
version          '4.4.1'

# For CLI client
# https://github.com/redguide/nodejs
depends 'nodejs', '~> 2.4'

# For ChefInfluxDB Chef handler
# https://github.com/jakedavis/chef-handler-influxdb
depends 'chef_handler'

# For apt and yum repositories
depends 'apt', '~> 2.7'
depends 'yum', '~> 3.6'

# For compatibility with 12.X versions of Chef
depends 'compat_resource'

chef_version '>= 12.0' if respond_to?(:chef_version)
source_url 'https://github.com/bdangit/chef-influxdb' if respond_to?(:source_url)
issues_url 'https://github.com/bdangit/chef-influxdb/issues' if respond_to?(:issues_url)
