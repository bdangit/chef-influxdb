require 'spec_helper'

describe 'influxdb' do
  describe service('influxdb') do
    it { is_expected.to be_running }
  end

  let(:influxdb_verion) do
    command('eval "$(which influx) -version"').stdout
  end

  it 'should have influxdb version 1.0.2' do
    expect(influxdb_verion).to match(/1.0.2/)
  end
end
