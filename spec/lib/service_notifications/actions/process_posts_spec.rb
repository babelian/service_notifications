require 'spec_helper'

# ServiceNotifictions
module ServiceNotifications
  describe ProcessPosts, type: :operation do
    let(:template) { Fabricate(:template) }
    let(:request) { Fabricate(:request, config: template.config) }
    let(:post) { Fabricate(:post, request: request) }

    let(:input) do
      { request_id: post.request_id }
    end

    let(:processing_error) { StandardError.new('test') }

    it 'works' do
      expect_success
      expect(post.reload.processed_at).not_to be_nil
      expect(post.response).to match a_hash_including(
        body: post.content.body, status: post.channel.adapter[:status]
      )
    end

    it 'captures errors' do
      allow(ProcessPost).to receive(:call).with(post: post, debug: false).and_raise processing_error

      expect_failure
      expect(output.errors[:base]).to eq [{ post_id: post.id, error: processing_error }]
    end
  end
end