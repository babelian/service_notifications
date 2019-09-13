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

    it 'works' do
      expect_success
      post.reload

      expect(post.processed_at).not_to be_nil
      expect(post.response).to match a_hash_including(
        body: post.content.body,
        status: post.channel.adapter[:status]
      )
    end
  end
end