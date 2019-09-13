require 'spec_helper'

module ServiceNotifications
  describe Channels::NoOp do
    let(:options) do
      {
        value1: 'NewCo'
      }
    end

    let(:post) { Fabricate(:post) }

    let(:channel) do
      described_class.new(options)
    end

    it '.new with options' do
      expect(channel).to be_a(Channel)
      expect(channel.value1).to eq options[:value1]
    end

    it '#call' do
      expect(channel.call(post)).to be_a(Hash)
    end
  end
end