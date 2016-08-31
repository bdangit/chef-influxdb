require 'spec_helper'

describe 'influxdb' do
  describe service('influxdb') do
    it { is_expected.to be_running }
  end

  let(:influxdb_verion) do
    command('eval "$(which influx) -version"').stdout
  end

  it 'should have influxdb version 0.10.3' do
    expect(influxdb_verion).to match(/0.10.3/)
  end
end
