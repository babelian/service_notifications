require 'spec_helper'

module ServiceNotifications
  describe MakeRequest, type: :operation do
    let(:request) { output.request }
    let(:post) { output.posts.first }

    let(:shared_input) do
      {
        api_key: config.api_key,
        notification: 'namespace/test',
        instant: true,
        debug: true
      }
    end

    describe 'e2e Mail' do
      let(:kind) { 'mail' }

      let(:input) do
        shared_input.merge(
          objects: {
            content: 'Request Email Content',
            from: 'NewCo<test@test.co>'
          },
          recipients: [
            { uid: 1, email: 'dev@lark42.com', objects: { name: 'Dev' } }
          ]
        )
      end

      before do
        Fabricate(:plain_mail_template, config: config)
        Fabricate(:html_mail_template, config: config)
      end

      it 'works' do
        pending "ENV['MAILGUN_API_KEY'] not set" if ENV['MAILGUN_API_KEY'].nil?

        expect_success

        expect(request.objects).to match a_hash_including(input[:objects])

        expect(post).to be_a(Post)
        expect(post.data).to eq(input[:recipients].first)
        expect(post.response).to match a_hash_including(
          to: input[:recipients].first[:email],
          from: input[:objects][:from]
        )
        expect(post.processed_at).not_to be_nil
      end

      # it 'live', skip: ENV['_'].match?(/guard/) ? false : 'not run in CI' do
      #   input[:debug] = false
      #   expect(post.response).to match a_hash_including(id: a_string_including('.mailgun.org'))
      # end
    end

    describe 'e2e Slack' do
      let(:kind) { 'slack' }

      let(:input) do
        shared_input.merge(
          objects: { text: 'hello' }
        )
      end

      before { template }

      it 'works' do
        expect_success
        expect(post).to be_a(Post)
        expect(post.response).to match a_hash_including(
          mrkdwn: true, text: 'hello', username: 'Config Tester'
        )
        expect(post.processed_at).not_to be_nil
      end

      # set ENV['SLACK_URL'] to test
      # it 'live', skip: ENV['_'].match?(/guard/) ? false : 'not run in CI' do
      #   input[:debug] = false
      #   expect_success
      #   expect(post.response).to match a_hash_including(body: 'ok')
      # end
    end
  end
end