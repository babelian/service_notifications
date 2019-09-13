# frozen_string_literal: true

module ServiceNotifications
  module Adapters
    # Send email through {Mail}
    class NoOp < Adapter
      params do
        status
      end

      def call
        payload
      end

      def debug
        payload.merge(debugged: true)
      end

      private

      def payload
        { body: content.body, status: status }
      end
    end
  end
end