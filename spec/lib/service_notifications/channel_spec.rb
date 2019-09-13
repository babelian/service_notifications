require 'spec_helper'

module ServiceNotifications
  describe Channel do
    describe '.load' do
      it '(channels)' do
        options = Fabricate.build(:config).data[:channels].merge(
          Fabricate.build(:mail_config).data[:channels]
        )
        channels = described_class.load(options)
        expect(channels.map(&:name).sort).to eq %w[mail no_op]
      end

      it '(name, options)' do
        channel = described_class.load('no_op', value1: 'val 1')
        expect(channel).to be_a(Channels::NoOp)
        expect(channel.name).to eq('no_op')
        expect(channel.value1).to eq('val 1')
        expect(channel.value2).to eq('default')
      end
    end

    #
    # Instance Methods
    #

    it '.new without options works' do
      expect(subject).to be_a(Channel)
    end

    it '#enabled is true by default' do
      expect(subject.enabled).to be true
    end

    it '#name is the class name underscored without namespacing' do
      expect(subject.name).to eq('channel')
    end

    it '#to_s is #name' do
      expect(subject.to_s).to eq(subject.name)
    end
  end
end