# frozen_string_literal: true

module ServiceNotifications
  module Models
    # Post
    module Post
      def self.included(base)
        base.include Models::Base
      end

      # @return [Adapter]
      def adapter
        Adapter.load channel.adapter.merge(content: content)
      end

      # @return [Channel]
      def channel
        request.channels[kind]
      end

      def config
        request.try(:config)
      end

      # @return [Content]
      def content
        Content.load(channel.name, post: self)
      end

      def data
        super || {}
      end

      def objects
        (
          request.try(:objects) || {}
        ).deep_merge(
          data[:objects] || {}
        )
      end

      def response
        super || {}
      end

      # @abstract
      def templates
        raise 'define in subclass'
      end
    end
  end
end