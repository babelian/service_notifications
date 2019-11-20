# frozen_string_literal: true

require 'liquid'

module ServiceNotifications
  # Render a Liquid Template (https://shopify.github.io/liquid/basics/introduction)
  #
  # @attr [String] template, a String or {Template}
  class Renderer < Initializer
    DEFAULT_LIQUID_OPTIONS = {
      error_mode: :strict,
      strict_filters: true,
      strict_variables: true
    }.freeze

    # Filters for {Liquid::Template}
    module Filters
      # @example
      #   "{{ '100USD' | money: 'no_cents' }}"
      #   money('100USD', :no_cents) => $1
      def money(input, format = nil)
        amount, currency = input.scan(/([0-9]*)([A-Z]{3})/).first
        raise "invalid input: #{input}" unless amount

        format ||= :default
        options = (@context.registers[:money_options] || {}).deep_symbolize_keys
        options = options[format.to_sym] || {}

        require 'money'
        Money.locale_backend = :currency # depreciation warning
        Money.new(amount.to_i, currency).format(options)
      end

      def time(input, format = nil)
        format ||= '%FT%T%:z'
        Time.parse(input).strftime(format)
      end
    end

    params do
      template :string
    end

    # @param [Hash] See https://shopify.github.io/liquid/basics/introduction/#objects
    # @return [String]
    def call(objects, registers = nil)
      string = liquid.render(
        objects.deep_stringify_keys,
        registers: (registers || objects).deep_symbolize_keys,
        filters: [Filters]
      )

      if error = liquid.errors.first
        liquid.errors.clear
        raise error.cause
      end

      string
    end

    # @return [Liquid::Template] loaded with the {template}
    def liquid
      @liquid ||= Liquid::Template.parse(template, DEFAULT_LIQUID_OPTIONS)
    end
  end
end