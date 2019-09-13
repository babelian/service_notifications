require 'spec_helper'

module ServiceNotifications
  describe Request, type: :model do
    let(:data) do
      Fabricate.build(:request).data
    end

    let(:notification) do
      Fabricate.build(:request).data[:notification]
    end

    let(:request) { Fabricate(:request, data: data) }
    let(:config) { request.config }
    let(:template) { Fabricate(:no_op_template, config: config) }

    before do
      template
    end

    it '.create' do
      expect(request).to be_persisted
      expect(request.notification).to eq(notification)
    end

    #
    # Instance Methods
    #

    it '#data serializes' do
      data = request.data
      expect(request.reload.data).to eq data
    end

    describe '#channels' do
      let(:channel) { request.channels[:no_op] }

      it 'overrides from #data' do
        expect(channel.value1).to eq(request.data[:channels][:no_op][:value1])
      end

      it 'inherits from #config.data' do
        expect(channel.value2).to eq(config.data[:channels][:no_op][:value2])
      end

      pending 'multiple channels'
    end

    describe '#recipients' do
      let(:wildcard_recipient) do
        recipient_data(1, '*')
      end

      let(:exact_match_recipient) do
        recipient_data(2, notification)
      end

      let(:not_subscribed_recipient) do
        recipient_data(3, 'other')
      end

      let(:data) do
        Fabricate.build(:request).data.merge(
          recipients: [
            wildcard_recipient,
            exact_match_recipient,
            not_subscribed_recipient
          ]
        )
      end

      it 'filters to subscribed' do
        expect(request.recipients.map(&:uid)).to eq [1, 2]
      end

      private

      def recipient_data(id, *subscriptions)
        {
          uid: id, email: "#{id}@example.com",
          subscriptions: subscriptions
        }
      end
    end

    it '#template_version' do
      expect(request.template_version).to eq 'v1'
    end

    describe '#templates' do
      before do
        Template.delete_all
        Fabricate(:template, config: config, format: 'plain')
        Fabricate(:template, config: config, format: 'html')
      end

      it 'pulls correct notification type' do
        expect(request.templates.to_a.length).to eq(2)
        expect(request.templates.first).to be_a(Template)
        expect(request.templates.map(&:notification).uniq).to eq [request.notification]
        expect(request.templates.map(&:version).uniq).to eq [request.template_version]
      end
    end
  end
end