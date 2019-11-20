# frozen_string_literal: true

module ServiceNotifications
  # Receive the {Post}, run {Post#adapter.call}, and mark processed.
  class ProcessPost < Action
    input do
      debug :boolean, default: false
      post_id :integer, optional: true
      post Post, optional: true
    end

    output do
      post Post
    end

    before do
      require_at_least_one_of(:post_id, :post)
    end

    # @todo Error handling, esp ActiveRecord edge case.
    def call
      return if processed?

      post.response = debug ? post.adapter.debug : post.adapter.call
      post.processed_at = Time.now
      post.save!
    end

    private

    def post
      context { Post.find(post_id) }
    end

    def processed?
      post.processed_at
    end
  end
end