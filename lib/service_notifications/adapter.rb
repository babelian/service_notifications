# frozen_string_literal: true

require 'rest-client'

module ServiceNotifications
  # An Adapter for a third party service {Channel}.
  # Eg {Channels::Mail} works with {Adapters::MailGun}.
  #
  # @abstract
  class Adapter < Initializer
    params do
      content Content
    end

    # @return [Hash]
    def call
      raise 'define in subclass'
    end

    # @return [Hash]
    def debug
      payload
    end

    private

    # Basic Rest API client wrapper. Will raise for any non http status outside of the 200 range.
    # @param [Symbol] method http :post, :get, etc,
    # @return [Hash] with symbolized keys.
    def request(method, *args)
      response = RestClient.send(method, *args)
      raise "#{response.code}: #{response.body}" unless (200..299).cover? response.code

      body = response.body
      body.first == '{' ? JSON.parse(body, symbolize_names: true) : { body: body }
    rescue RestClient::BadRequest => e
      raise "#{e.http_code}: #{e.http_body}"
    end
  end
end