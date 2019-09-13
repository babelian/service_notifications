require 'spec_helper'

module ServiceNotifications
  describe Contents::NoOp do
    let(:post) { Fabricate(:post) }
    let(:options) do
      { post: post }
    end

    let(:content) do
      described_class.new(options)
    end

    before do
      Fabricate(:template, config: post.request.config)
    end

    it '.new with options' do
      expect(content).to be_a(described_class)
      expect(content.body).to eq 'The company is NewCo'
    end
  end
end