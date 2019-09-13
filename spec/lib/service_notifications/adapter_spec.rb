require 'spec_helper'

module ServiceNotifications
  describe Adapter do
    describe '.load' do
      let(:adapter) do
        described_class.load('no_op', status: 'Something', content: Content.new(post: Post.new))
      end

      it 'constantizes and sets' do
        expect(adapter).to be_a(Adapters::NoOp)
        expect(adapter.content).to be_a(Content)
        expect(adapter.status).to eq('Something')
      end
    end
  end
end