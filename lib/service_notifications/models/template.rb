# frozen_string_literal: true

module ServiceNotifications
  module Models
    # Example data:
    #   version: v1
    #   notification: welcome
    #   channel: mail
    #   format: plain
    #   data: |-
    #     Subject: Welcome to the platform!
    #     Hi {{name}},
    #     Welcome...
    #
    module Template
      def self.included(base)
        base.include Models::Base
      end

      def to_s
        data.to_s
      end
    end
  end
end