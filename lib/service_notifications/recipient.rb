# frozen_string_literal: true

module ServiceNotifications
  # Recipent value object to be used for subscription management and interpolations
  class Recipient < Initializer
    DATA_KEYS = [
      :uid, :email, :phone, :objects #, variables
    ].freeze

    # Post Data
    params do
      uid
      email :string, optional: true
      phone :string, optional: true

      objects :hash, default: -> { {} }
      #variables :Hash, default: -> { {} }

      # not passed through to Post
      channels :array, default: -> { ['*'] }
      subscriptions :array, default: -> { ['*'] }
    end

    #
    # Class Methods
    #

    class << self
      # @param [Array<Hash>] of recipient attributes
      # @return [Array<Recipient>]
      def load(array)
        array.map { |attributes| Recipient.new(attributes) }
      end
    end

    #
    # Instance Methods
    #

    # @param [Recipient]
    # @return [true, false]
    def ==(other)
      uid == other.uid
    end

    # @return [Hash] of options to be passed through to {Post#data}
    def data
      DATA_KEYS.each_with_object({}) do |k, h|
        v = send(k)
        h[k] = v if v
      end
    end

    # Whether this recipient wants this notification based on their subscription/channel settings
    # @param [String] subscription name
    # @param [String] channel name
    # @return [Boolean]
    def post?(subscription, channel)
      channel?(channel) && subscription?(subscription)
    end

    # @param [String] channel name
    # @return [Boolean]
    def channel?(channel)
      regexp_match?(channel.to_s, channels)
    end

    # @param [String] subscription name
    # @return [Boolean]
    def subscription?(subscription)
      regexp_match?(subscription, subscriptions)
    end

    private

    def regexp_for(list)
      Regexp.new(
        '^(' + list.map { |s| Regexp.quote(s).gsub('\*', '.*') }.join('|') + ')$'
      )
    end

    def regexp_match?(item, list)
      !(item =~ regexp_for(list)).nil?
    end
  end
end