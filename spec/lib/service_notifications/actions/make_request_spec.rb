require 'spec_helper'

# ServiceNotifictions
module ServiceNotifications
  describe MakeRequest, type: :operation, skip: true do
    let(:config) { Fabricate(:config) }
    let(:notification) { 'test' }

    let(:recipients) do
      [recipient_data(1)]
    end

    let(:input) do
      {
        api_key: config.api_key,
        notification: notification,
        recipients: recipients
      }
    end

    let(:request) { output.request }
    let(:job) { output.make_posts_job }

    describe 'failure' do
      it 'requires an api_key' do
        input.delete(:api_key)
        expect_failure
        expect(output.errors[:api_key]).to eq ["can't be blank"]
      end

      it 'requires a valid api_key' do
        input[:api_key] += '111'
        expect(output.errors[:base]).to eq [described_class::ERRORS[:authorization_failed]]
      end

      # it 'passes through Request::SCHEMA errors' do
      #   input[:notification] = 1
      #   expect(output.data_errors).to be_present
      # end
    end

    describe 'succees' do
      it 'creates Request' do
        expect(output.request).to be_a(Request)
        expect(output.request.errors).to be_blank
        expect(output.request).to be_persisted
      end

      it 'delays MakePosts' do
        expect(job).to be_a(Delayed::Job)
        expect(job.payload_object.object).to eq(MakePosts)
        expect(job.payload_object.args).to eq [request_id: request.id]
      end

      it 'runs MakePosts instantly when instant: true' do
        input[:instant] = true
        allow(MakePosts).to receive(:call).with(
          request: kind_of(Request), instant: true, debug: false
        ).and_return(
          OpenStruct.new(posts: [1])
        )
        expect(output.posts).to eq [1]
      end

      it 'debug: true bypasses adapter.call' do
        input[:debug] = true
        expect(output.posts.first.response).to match a_hash_including(debugged: true)
      end
    end
  end
end