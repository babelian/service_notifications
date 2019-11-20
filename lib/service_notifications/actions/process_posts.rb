# frozen_string_literal: true

module ServiceNotifications
  # Receive the request, validate it and Queue
  class ProcessPosts < Action
    input do
      debug :boolean, default: false

      request_id :integer, optional: true
      request Request, optional: true
    end

    before do
      require_at_least_one_of(:request_id, :request)
    end

    def call
      posts.each(&method(:process))
    end

    private

    def posts
      context { request.unprocessed_posts }
    end

    def request
      context { Request.find(request_id) }
    end

    # @todo Error handling, retry of posts.
    def process(post)
      ProcessPost.call(post: post, debug: debug)
    rescue StandardError => e
      errors.add(:base, post_id: post.id, error: e)
    end
  end
end