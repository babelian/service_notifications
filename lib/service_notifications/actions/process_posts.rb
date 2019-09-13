# frozen_string_literal: true

module ServiceNotifications
  # Receive the request, validate it and Queue
  class ProcessPosts < Action
    input do
      debug :boolean, default: false

      request_id :integer, optional: true
      request 'service_notifications/request', optional: true
    end

    def call
      posts.each(&method(:process))
      fail! if context.errors.present?
    end

    before do
      require_at_least_one_of(:request_id, :request)
    end

    private

    def posts
      context.posts ||= request.unprocessed_posts
    end

    def process(post)
      ProcessPost.call(post: post, debug: debug)
    rescue StandardError => e
      puts e.inspect
      puts e.backtrace
      context.errors ||= []
      context.errors << { post_id: post.id, error: e }
    end

    def request
      context.request ||= Request.find(request_id)
    end
  end
end