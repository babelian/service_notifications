# frozen_string_literal: true

module ServiceNotifications
  # Receive the request, validate it and Queue
  class ProcessPost < Action
    input do
      debug :boolean, default: false
      post_id :integer, optional: true
      post 'service_notifications/post', optional: true
    end

    output do
      post 'service_notifications/post'
    end

    before do
      require_at_least_one_of(:post_id, :post)
    end

    def call
      return if processed?

      post.response = debug ? post.adapter.debug : post.adapter.call
      post.processed_at = Time.now
      post.save!
    end

    private

    def post
      context.post ||= Post.find post_id
    end

    def processed?
      post.processed_at
    end
  end
end