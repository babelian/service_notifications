require './lib/service_notifications/version'

Gem::Specification.new do |s| # rubocop:disable Metrics/BlockLength
  s.name        = 'service_notifications'
  s.version     = ServiceNotifications::VERSION

  s.summary     = 'Multi-Tenant templated notification system for Email/SMS/Slack etc'
  s.homepage    = 'https://github.com/babelian/service_notifications'
  s.authors     = ['Zach Powell']
  s.email       = 'zach@babelian.net'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.5.3'

  s.files = Dir.glob('{lib}/**/*')
  s.require_paths = %w[lib]

  # AR
  s.add_runtime_dependency 'activerecord', '>=5.2.0'
  s.add_runtime_dependency 'delayed_job_active_record', '>=4.1.3'
  s.add_runtime_dependency 'standalone_migrations', '5.2.5'

  # DynamoDB
  s.add_runtime_dependency 'dynamoid', '3.1.0'
  s.add_runtime_dependency 'tzinfo-data'

  # Action/Schemas
  s.add_runtime_dependency 'parametric', '0.2.5'

  # Rendering / Requests
  s.add_runtime_dependency 'liquid', '4.0.1'
  s.add_runtime_dependency 'money', '~> 6'
  s.add_runtime_dependency 'premailer', '1.11.1'
  s.add_runtime_dependency 'rest-client', '2.0.2'

  # Dev
  s.add_runtime_dependency 'nokogiri', '1.9.1'

  s.add_development_dependency 'database_cleaner', '1.7.0'
  s.add_development_dependency 'fabrication', '2.20.1'
  s.add_development_dependency 'guard', '2.15.0'
  s.add_development_dependency 'guard-bundler', '2.1.0'
  s.add_development_dependency 'guard-rspec', '4.7.3'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rack-test', '0.8.3'
  s.add_development_dependency 'rake', '12.3.2'
  s.add_development_dependency 'rspec', '3.7.0'
  s.add_development_dependency 'simplecov', '0.16.1'
  s.add_development_dependency 'sqlite3' # in Dockerfile
  s.add_development_dependency 'yard', '0.9.16'
end