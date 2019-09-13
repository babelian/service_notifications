# frozen_string_literal: true

module ServiceNotifications
  module Channels
    # Dummy Channel for Testing
    class NoOp < Channel
      params do
        value1
        value2 optional: true, default: -> { 'default' }
      end

      def call(post)
        { post_id: post.id, value1: value1, value2: value2 }
      end
    end
  end
end