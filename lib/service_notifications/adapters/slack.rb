# frozen_string_literal: true

require 'rest-client'

module ServiceNotifications
  module Adapters
    # Post to Slack
    class Slack < Adapter
      params do
        content Contents::Slack
        url :string
      end

      delegate :payload, to: :content

      def call
        request :post, url, JSON.generate(payload)
      rescue RestClient::BadRequest => e
        raise "#{e.http_code}: #{e.http_body}"
      end
    end
  end
end