# Entrypoint for AWS Lamba

require 'bundler/setup'
require 'service_notifications/aws'

include ServiceNotifications # rubocop:disable Style/MixinUsage

def make_request(event:, context:)
  body = event['body'] || event.deep_symbolize_keys
  body = JSON.parse(body, symbolize_names: true) if body.is_a?(String)
  result = MakeRequest.call(body)
  { statusCode: result.success? ? 200 : 400, body: result.to_h.except(:config).to_json }
rescue StandardError => e
  result = { message: e.message, backtrace: e.backtrace.join("\n"), env: ENV }
  { statusCode: 500, body: result.to_json }
end