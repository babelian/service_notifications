require 'spec_helper'

module ServiceNotifications
  describe Adapters::Slack do
    let(:content) do
      Content.load('slack', post: Post.new)
    end

    let(:url) { 'https://slack.com/slack' }

    let(:options) do
      { url: url, content: content }
    end

    let(:adapter) do
      described_class.new(options)
    end

    before do
      allow(RestClient).to receive(:post).with(url, JSON.generate(content.payload)).and_return(
        OpenStruct.new(code: 200, body: { ok: 1 }.to_json)
      )
    end

    it '.new with options' do
      expect(adapter).to be_a(described_class)
      expect(adapter.call).to match a_hash_including(ok: 1)
    end
  end
end