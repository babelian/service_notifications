require 'rubygems'
require 'rspec/core/rake_task'

require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = '--format documentation --require spec_helper.rb'
end

task default: :spec