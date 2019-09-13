# frozen_string_literal: true

module ServiceNotifications
  module Models
    # Template
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