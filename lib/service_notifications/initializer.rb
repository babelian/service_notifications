# frozen_string_literal: true

require 'service_operation'

module ServiceNotifications
  # Abstract Initialization class to make objects with validated params.
  #
  # @abstract
  # @todo remove {ServiceOperation::Base} dependency to remove business logic modules.
  class Initializer
    include ServiceOperation::Base

    class << self
      def call(*args)
        new(*args).call
      end

      # @example
      #   Initializer.load(:sublcass, option: 1)
      # @example
      #   Initializer.load(name: :subclass, option: 1)
      # @param [Symbol,String] name of subclass
      # @param [Hash] options, which can optionally include a :name key
      # @return an instance of the class
      def load(*args)
        name = args.last[:name] || args.first
        options = args.last
        lookup(name).new(options)
      end

      def lookup(name)
        "#{self.name.pluralize}::#{name.to_s.camelize}".constantize
      end
    end

    # Shim to use ServiceOperation::Params as an object rather than call
    def initialize(*args)
      super
      validate_params
    end
  end
end