require_relative '../../../kitchen/data/spec_helper'

describe 'prometheus service' do
  describe service('prometheus') do
    it { should be_running }
  end

  describe port(9090) do
    it { should be_listening }
  end

  describe 'prometheus should be exposing metrics' do
    describe command("wget 'http://localhost:9090/metrics' -q -O -") do
      its(:stdout) { should match(/prometheus_notifications_queue_capacity 100/) }
    end
  end
end