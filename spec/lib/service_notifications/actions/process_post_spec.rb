require 'spec_helper'

# ServiceNotifictions
module ServiceNotifications
  describe ProcessPost, type: :operation do
    let(:input) do
      { post: post }
    end

    context 'success' do
      it 'works' do
        expect_success
        post.reload
        expect(post.processed_at).not_to be_nil
        expect(post.response).to match a_hash_including(
          body: post.content.body,
          status: post.channel.adapter[:status]
        )
      end

      it 'debug: true skips call' do
        input[:debug] = true
        expect_success
        post.reload
        expect(post.response).to match a_hash_including(debugged: true)
      end

      context 'already processed' do
        let(:processed_at) { 2.days.ago }

        before do
          post.update_attributes(processed_at: processed_at)
          expect_success
          post.reload
        end

        it 'does not reprocess' do
          expect(post.processed_at.to_date).to eq(processed_at.to_date)
          expect(post.response).to be_blank
        end
      end
    end
  end
end