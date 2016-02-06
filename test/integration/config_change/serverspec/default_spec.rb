require 'spec_helper'

describe 'influxdb' do
  describe user('influxdb') do
    it { is_expected.to exist }
  end

  describe service('influxdb') do
    it { is_expected.to be_running }
  end

  describe port(8083) do
    it { is_expected.to be_listening }
  end

  describe port(8086) do
    it { is_expected.to be_listening }
  end

  describe 'graphite' do
    describe port(2003) do
      it { is_expected.to be_listening }
    end
  end
end
