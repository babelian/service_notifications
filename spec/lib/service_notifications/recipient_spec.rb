require 'spec_helper'

module ServiceNotifications
  describe Recipient do
    let(:channels) { %w[mail sms] }
    let(:subscriptions) { %w[one namespaced/one namespaced/all/*] }

    let(:attributes) do
      {
        uid: SecureRandom.uuid,
        name: 'First Last',
        email: 'user@example.com',
        phone: '123',

        objects: { name: 'First Last' },
        # variables: { first_name: 'First' },

        channels: channels,
        subscriptions: subscriptions
      }
    end

    let(:recipient) do
      described_class.new attributes
    end

    describe '.load' do
      it 'works' do
        recipients = described_class.load([attributes])
        expect(recipients).to eq [recipient]
      end
    end

    it '.new' do
      expect(recipient).to be_a(described_class)
    end

    it '== matches on uid' do
      expect(recipient).to eq described_class.new(attributes)
    end

    describe '#data' do
      it 'works' do
        expect(recipient.data).to eq attributes.slice(*described_class::DATA_KEYS)
      end
    end

    describe '#post?' do
      {
        true => [
          %w[one mail], %w[one sms], %w[namespaced/all/message mail]
        ],
        false => [
          %w[one slack], %w[two mail]
        ]
      }.each do |bool, pairs|
        pairs.each do |subscription, channel|
          it "#{subscription},#{channel} => #{bool}" do
            expect(recipient.post?(subscription, channel)).to be bool
          end
        end
      end
    end

    describe '#channel?' do
      {
        true => %w[mail sms] + [:mail_channel],
        false => %w[email]
      }.each do |bool, channels|
        channels.each do |channel|
          it "#{channel} => #{bool}" do
            channel = send(channel) if channel.is_a?(Symbol)
            expect(recipient.channel?(channel)).to be bool
          end
        end
      end
    end

    describe '#subscription?' do
      {
        true => %w[one namespaced/one namespaced/all/something],
        false => %w[two namespaced/one/two namespaced/all]
      }.each do |bool, notifications|
        notifications.each do |notification|
          it "#{notification} => #{bool}" do
            expect(recipient.subscription?(notification)).to be bool
          end
        end
      end
    end
  end
end