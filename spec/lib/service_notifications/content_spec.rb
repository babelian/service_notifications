require 'spec_helper'

module ServiceNotifications
  describe Content do
    it 'works' do
      expect(described_class.new(post: Post.new)).to be_a(described_class)
    end
  end
end