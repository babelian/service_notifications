# frozen_string_literal: true

module ServiceNotifications
  module Channels
    # Send email through {Mail}
    class Mail < Channel
      params do
        from :string
        reply_to :string
      end
    end
  end
end