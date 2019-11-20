# frozen_string_literal: true

require 'parametric'

module ServiceNotifications
  module Models
    # Request. Links a unique payload ({#data}) with a {Config}.
    module Request
      def self.included(base)
        base.include Models::Base
      end

      # Example:
      #   notification: 'welcome'
      #   recipients: [{ uid: 1, email: 'bob@example.com', objects: { first_name: 'Bob' } }]
      #   objects: { site: 'Name of Site', url: 'https://example.com/welcome' }
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

      # @return [Hash]
      def data
        super || {}
      end

      # @return [String]
      def notification
        super || begin
          self[:notification] = data[:notification]
          super
        end
      end

      # @return [Hash]
      def objects
        @objects ||= (hydrated_data[:objects] || {})
      end

      # @return [Array<Recipient>}] filtered by whether they are subscribed to the {#notification}.
      def recipients
        @recipients ||= Recipient.load(recipients_data).select do |recipient|
          recipient.subscription?(notification)
        end
      end

      def template_version
        hydrated_data[:template_version]
      end

      # @abstract
      # @return [Array<Template>]
      def templates
        raise 'define in subclass'
      end

      # @abstract
      # @return [Array<Post>]
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