require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe command('/etc/init.d/influxdb start') do
  it { should return_exit_status 0 }
end

describe user('influxdb') do
  it { should exist }
end

describe service('influxdb') do
  it { should be_running }
end
