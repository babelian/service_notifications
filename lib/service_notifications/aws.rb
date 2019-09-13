# frozen_string_literal: true

puts 'loading Dynamoid'

require 'dynamoid'

# Reset strategy from https://github.com/Dynamoid/dynamoid
module DynamoidReset
  def self.all
    Dynamoid.adapter.list_tables.each do |table|
      # Only delete tables in our namespace
      Dynamoid.adapter.delete_table(table) if table =~ /^#{Dynamoid::Config.namespace}/
    end
    Dynamoid.adapter.tables.clear
    # Recreate all tables to avoid unexpected errors

    Dynamoid.included_models.each { |m| m.create_table(sync: true) }
  end

  Dynamoid.logger.level = Logger::FATAL
end

puts 'configuring Dynamoid'

Dynamoid.configure do |config|
  config.namespace = ENV['ENVIRONMENT'] || 'development'
  # config.endpoint = 'http://localhost:3000'
  config.access_key = ENV['DYNAMODB_ACCESS_KEY_ID'] || ENV['AWS_ACCESS_KEY_ID']
  config.secret_key = ENV['DYNAMODB_SECRET_ACCESS_KEY'] || ENV['AWS_SECRET_ACCESS_KEY']
  config.region = ENV['DYNAMODB_REGION'] || ENV['AWS_REGION'] || 'us-east-1'
  config.logger = false
end

puts "Dynamoid loaded in #{Dynamoid::Config.namespace}"

puts 'loading ServiceNotifications'

require 'service_notifications'

# ServiceNotifications load Dynamoid version of models
module ServiceNotifications
  autoload_dir(self, 'service_notifications/models/dynamoid')
end

puts 'Ready'