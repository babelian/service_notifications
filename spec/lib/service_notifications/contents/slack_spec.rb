require 'spec_helper'

module ServiceNotifications
  describe Contents::Slack do
    let(:post) { Fabricate(:slack_post) }

    let(:options) do
      { post: post }
    end

    let(:content) do
      described_class.new(options)
    end

    let(:expected_data) do
      post.objects.merge(mrkdwn: true)
    end

    it '.new with options' do
      expect(content).to be_a(described_class)
      expect(content.payload).to match a_hash_including(expected_data)
    end
  end
end