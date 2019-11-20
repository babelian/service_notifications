require 'spec_helper'

module ServiceNotifications
  describe Post, type: :model do
    let(:no_op) { 'mail' }

    it '.create' do
      expect(post).to be_persisted
    end

    it 'validates #request_id' do
      subject.valid?
      expect(subject.errors[:request_id]).to be_present
    end

    #
    # Instance Methods
    #

    it '#channel is loaded from request' do
      expect(post.channel).to be_a(Channel)
      expect(post.channel.name).to eq(post.kind)
    end

    it '#content' do
      expect(post.content).to be_a(Content)
      expect(post.content.post).to eq(post)
    end

    it '#templates' do
      Fabricate(:template, channel: 'non_matching_channel', config: config)
      expect(post.templates.to_a).to eq [template]
    end
  end
end