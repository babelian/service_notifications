require 'spec_helper'

module ServiceNotifications
  describe Channels::Slack do
    subject do
      described_class.new(options)
    end

    let(:options) do
      {}
    end

    it '.new with options' do
      expect(subject).to be_a(Channel)
    end
  end
end