# frozen_string_literal: true

module ServiceNotifications
  module Contents
    # Slack Content
    # https://api.slack.com/messaging/sending
    # https://api.slack.com/messaging/composing
    # https://api.slack.com/tools/block-kit-builder
    #
    # @todo depreciate in favor of Contents::Chat and abstract Slack payload.
    class Slack < Content
      PAYLOAD_DEFAULTS = {
        mrkdwn: true,
        # icon_url: '',
        unfurl_links: false
      }.freeze

      def payload
        PAYLOAD_DEFAULTS.merge(objects)
      end
    end
  end
end