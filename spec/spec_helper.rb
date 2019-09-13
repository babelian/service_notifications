require 'simplecov'
SimpleCov.start

require 'fabrication'
require 'ruby_extensions/pry'
require 'service_operation/spec/spec_helper'

if ENV['AWS']
  require 'service_notifications/aws'
else
  require 'active_record'
  require 'database_cleaner'
  require 'sqlite3'
  require 'service_notifications'
  ActiveRecord::Base.establish_connection(YAML.load_file('db/config.yml')['test'])
end

require 'support/fixture_contexts'

RSpec.configure do |config|
  config.include_context 'fixtures'
  config.include_context 'operation', type: :operation

  if ENV['_'].to_s.match?(/guard/)
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
  end

  # Scrub tables between runs:
  if ENV['AWS']
    config.before(:suite) do
      ServiceNotifications::Config.name # ensure models are loaded
      Dynamoid.included_models.each do |m|
        m.where({}).delete_all
      end
      # DynamoidReset.all
    end
  else
    # if ServiceNotifications::ApplicationRecord.is_a?(ActiveRecord::Base)
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.around do |example|
      DatabaseCleaner.cleaning do
        example.run
      end
    end
  end
end