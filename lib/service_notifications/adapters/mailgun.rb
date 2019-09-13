# frozen_string_literal: true

module ServiceNotifications
  module Adapters
    # Send {Contents::Mail} through MailGun (https://mailgun.com)
    class Mailgun < Adapter
      DOMAIN_FROM_HEADER_REGEXP = /@([^>]*)[>]{0,1}$/

      # MailGun Params
      PARAMS = [
        :from,
        # reply_to,
        :to,
        # cc,
        # bcc,
        :subject,
        :text,
        :html,
        # attachments
      ].freeze

      params do
        content Contents::Mail
        api_key :string, default: -> { ENV['MAILGUN_API_KEY'] }
        domain :string, default: -> { ENV['MAILGUN_DOMAIN'] }
      end

      #
      # Instance Methods
      #

      def call
        request(:post, url, payload).except(:message)
      rescue RestClient::BadRequest => e
        raise "#{e.http_code}: #{e.http_body}"
      end

      # def domain
      #   super || content.from[DOMAIN_FROM_HEADER_REGEXP, 1]
      # end

      def payload
        PARAMS.each_with_object({}) do |k, hash|
          hash[k] = send(k)
        end
      end

      def text
        content.plain
      end

      private

      def url
        "https://api:#{api_key}@api.mailgun.net/v3/#{domain}/messages"
      end

      def method_missing(method_name, *args, &block)
        if param_method_exists?(method_name)
          content.send(method_name, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        param_method_exists?(method_name) || super
      end

      def param_method_exists?(method_name)
        PARAMS.include?(method_name.to_sym)
      end
    end
  end
end