# frozen_string_literal: true

module ServiceNotifications
  module Models
    # Base, which validates the class {SCHEMA} if it exists
    #
    # @todo rename {data_errors} to {schema_errors}
    module Base
      def self.included(base)
        base.validate do
          errors.add(:data, data_errors.inspect) if data_errors.any?
        end
      end

      def data_errors
        @data_errors ||= schema ? schema.resolve(data).errors : {}
      end

      # @return [Parametric::Schema, NilClass]
      def schema
        return unless defined?(self.class::SCHEMA)

        self.class::SCHEMA
      end
    end
  end
end