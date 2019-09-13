require 'spec_helper'

module ServiceNotifications
  describe Channels::Mail do
    let(:options) do
      {
        from: 'NewCo',
        reply_to: 'noreply@new.co'
      }
    end

    let(:mail) do
      described_class.new(options)
    end

    it '.new with options' do
      expect(mail).to be_a(Channel)
    end
  end
end