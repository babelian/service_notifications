# frozen_string_literal: true

require 'parametric'

module ServiceNotifications
  module Models
    # Config
    module Config
      def self.included(base)
        base.include Models::Base
      end

      # See config_fabricator.rb for examples.
      SCHEMA = Parametric::Schema.new do
        field(:channels).type(:hash).schema do
          field(:mail).schema do
            field(:from).type(:string).required
            field(:reply_to).type(:string).required
            field(:adapter).type(:hash)
          end

          field(:no_op).schema do
            field(:value1).required
            field(:value2).required
          end
        end

        field(:interpolations).type(:hash)
        field(:objects).type(:hash)
        field(:template_version).type(:string).required
      end

      # @return [String]
      def api_key
        super || begin
          self[:api_key] = SecureRandom.hex(16)
          super
        end
      end

      # @return [Array<Channel>]
      def channels
        @channels ||= Channel.load data[:channels]
      end

      # @return [Hash]
      def data
        super || {}
      end

      # @return [Hash]
      def interpolations
        data[:interpolations] || {}
      end

      # @return [Hash]
      def hydrate_data(hash)
        data.except(:interpolations).deep_merge interpolate(hash)
      end

      private

      # traverse a hash converting values when they match {#interpolations}.
      # @return [Hash]
      def interpolate(hash)
        return hash unless interpolations.any?

        hash.reformat(&method(:interpolate_key_value))
      end

      def interpolate_key_value(key, value)
        return [key, value] unless key && value.is_a?(String)

        if args = interpolations[key.to_sym]
          value = value.gsub(*args)
        end

        [key, value]
      end
    end
  end
end