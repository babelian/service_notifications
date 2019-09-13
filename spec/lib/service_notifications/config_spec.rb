require 'spec_helper'

module ServiceNotifications
  describe Config, type: :model do
    let(:config) { Fabricate(:config) }

    it '.create' do
      expect(config).to be_persisted
      expect(config.api_key).to match(/[a-f0-9]{32}/)
      expect(config.data).to be_a(Hash)
    end

    it '#data serializes' do
      data = config.data
      expect(config.reload.data).to eq data
    end

    it '#channels' do
      expect(config.channels).to be_a(Array)
      expect(config.channels.first).to be_a(Channels::NoOp)
    end

    describe '#hydrate_data' do
      before do
        config.data[:interpolations] = {
          user: [/^(\w*):(\w*)$/, 'http://new.co/users/\1?tenant=\2']
        }
      end

      let(:data) do
        {}
      end

      let(:hydrated_data) do
        config.hydrate_data(data)
      end

      it 'deep merges hash over the top of config' do
        data[:channels] = { custom: {}, no_op: { value1: 'override', something: 1 } }

        expect(hydrated_data).to match a_hash_including(
          channels: config.data[:channels].deep_merge(data[:channels])
        )
      end

      it 'interpolates values' do
        data[:nested_users] = [{ user: 'one:two' }]
        expect(hydrated_data).to match a_hash_including(
          nested_users: [{ user: 'http://new.co/users/one?tenant=two' }]
        )
      end
    end
  end
end