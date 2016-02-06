source 'https://supermarket.chef.io'

metadata

# FIXME: keep to this branch until
#        https://github.com/chef-cookbooks/compat_resource/issues/37 is resolved
cookbook 'compat_resource', git: 'git://github.com/b-dean/compat_resource.git',
                            branch: 'require_resource_builder'

group :test do
  cookbook 'influxdb-test', path: 'test/fixtures/cookbooks/influxdb-test'
  cookbook 'netstat'
end
