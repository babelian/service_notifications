require 'spec_helper'

# ServiceNotifictions
module ServiceNotifications
  describe MakePosts, type: :operation do
    let(:recipient1_data) do
      {
        uid: SecureRandom.uuid,
        email: 'test1@example.com'
      }
    end

    let(:recipient2_data) do
      { uid: SecureRandom.uuid, email: 'test2@example.com' }
    end

    let(:recipients) do
      [recipient1_data, recipient2_data]
    end

    let(:request) do
      request = Fabricate(:request, config: template.config)
      request.data[:recipients] = recipients
      request.save!
      request
    end

    let(:template) { Fabricate(:no_op_template) }

    let(:input) do
      { request_id: request.id }
    end

    let(:job) { output.process_posts_job }

    delegate :posts, to: :output

    context 'success' do
      it 'works' do
        expect_success
      end

      it 'marks request processed' do
        expect(output.request).to eq request
        expect(output.request.processed_at).to be_present
      end

      it 'creates posts' do
        expect(posts.length).to eq(2)
        expect(posts.map(&:uid).sort).to eq request.recipients.map(&:uid).sort
      end

      it 'delays ProcessPosts' do
        expect(job).to be_a(Delayed::Job)
        expect(job.payload_object.object).to eq(ProcessPosts)
        expect(job.payload_object.args).to eq [request_id: request.id]
      end

      it 'runs ProcessPosts instantly when instant: true' do
        input[:instant] = true
        allow(ProcessPosts).to receive(:call!).and_return(true)
        expect_success
        expect(ProcessPosts).to have_received(:call!).with(kind_of(ServiceOperation::Context))
      end
    end

    context 'no recipients' do
      let(:recipients) { [] }

      it 'creates a single recipient' do
        expect_success
        expect(posts.first.uid).to eq 'none'
        expect(posts.first.data).to eq(uid: 'none', objects: {})
      end
    end
  end
end