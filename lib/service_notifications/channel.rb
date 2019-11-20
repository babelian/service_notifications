# frozen_string_literal: true

module ServiceNotifications
  # A destination to send a {Post} to.
  # Examples would be Mail, Chat, Text, Push. Antipattern would be Slack (should be Chat).
  #
  # @abstract
  class Channel < Initializer
    params do
      enabled :boolean, default: -> { true }
      adapter :hash, optional: true
    end

    class << self
      # @param [String, Hash] name of channel or Hash of { 'name' => options }
      # @param [Hash] options if passing a String for name
      # @return [Array<Channel>, Channel]
      def load(name, options = {})
        if name.is_a?(Hash)
          name.map { |k, v| load(k, v) }
        else
          super
        end
      end
    end

    # SomeChannel => 'some_channel'
    # @return [String] name of channel in underscore format
    def name
      self.class.name.split('::').last.underscore
    end

    alias to_s name
  end
end