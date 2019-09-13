# frozen_string_literal: true

module ServiceNotifications
  module Channels
    # Slack Notification
    # @todo: This is an anti-pattern, there should be a 'Chat' Channel that normalizes the standard
    # payload and then uses a Slack adapter.
    class Slack < Channel
    end
  end
end