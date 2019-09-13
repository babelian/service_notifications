# frozen_string_literal: true

require 'parametric'

module ServiceNotifications
  module Models
    # Request
    module Request
      def self.included(base)
        base.include Models::Base
      end

      SCHEMA = Parametric::Schema.new do
        field(:notification).type(:string).required
        field(:recipients).type(:array).required
        field(:objects).type(:hash)
      end

      # @return [Hash{String => Channel}]
      def channels
        @channels ||= Channel.load(channel_data.slice(*templated_channels))
                             .select(&:enabled).map { |c| [c.name, c] }
                             .to_h.with_indifferent_access
      end

      # which channels are actually available
      def templated_channels
        templates.map(&:channel).uniq.map(&:to_sym)
      end

      def data
        super || {}
      end

      def notification
        super || begin
          self[:notification] = data[:notification]
          super
        end
      end

      def objects
        @objects ||= (hydrated_data[:objects] || {})
      end

      def recipients
        @recipients ||= Recipient.load(recipients_data).select do |recipient|
          recipient.subscription?(notification)
        end
      end

      def template_version
        hydrated_data[:template_version]
      end

      # @abstract
      def templates
        raise 'define in subclass'
      end

      # @abstract
      def unprocessed_posts
        raise 'define in subclass'
      end

      private

      def hydrated_data
        @hydrated_data ||= config.hydrate_data(data)
      end

      def channel_data
        hydrated_data[:channels]
      end

      def recipients_data
        hydrated_data[:recipients]
      end
    end
  end
end