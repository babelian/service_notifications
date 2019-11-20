# frozen_string_literal: true

module ServiceNotifications
  module Models
    # Example data:
    #   kind: mail
    #   uid: 3rd party user id
    #   data: user payload (email, objects, etc)
    #   response: brief reply/confirmation from adapter.
    #
    # @todo remove {Content} dependency.
    module Post
      def self.included(base)
        base.include Models::Base
      end

      # @return [Channel]
      def channel
        request.channels[kind]
      end

      # @return [Config]
      def config
        request.try(:config)
      end

      # @return [Content]
      def content
        Content.load(channel.name, post: self)
      end

      # @return [Hash]
      def data
        super || {}
      end

      # @return [Hash] mix of {Request} objects and any post specific ones from the {Recipient}.
      def objects
        (
          request.try(:objects) || {}
        ).deep_merge(
          data[:objects] || {}
        )
      end

      # @return [Hash] response data from the {Adapter}.
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