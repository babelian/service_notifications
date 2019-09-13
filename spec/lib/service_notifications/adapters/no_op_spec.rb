require 'spec_helper'

module ServiceNotifications
  describe Adapters::NoOp do
    let(:content) do
      Content.load('no_op', post: Post.new)
    end

    let(:options) do
      { content: content, status: 'OK' }
    end

    let(:adapter) do
      described_class.new(options)
    end

    before do
      allow(content).to receive(:body).and_return('BODY')
    end

    it '.new with options' do
      expect(adapter).to be_a(described_class)
      expect(adapter.call).to match a_hash_including(body: 'BODY', status: options[:status])
    end
  end
end