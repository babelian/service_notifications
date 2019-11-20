# frozen_string_literal: true

require 'ruby_extensions/hash_extensions'
require 'service_operation'
require 'service_notifications/parametric'

Hash.include RubyExtensions::HashExtensions

def autoload_dir(mod, dir)
  dir_path = File.dirname(__FILE__) + "/#{dir}/"
  paths = Dir["#{dir_path}*.rb"].to_a
  paths.map do |path|
    path = path[/#{Regexp.quote(dir_path)}([^\.]*).rb/, 1]
    klass = path.camelize.to_sym
    mod.autoload klass, "#{dir}/#{path}"
  end
end

# ServiceNotifications
module ServiceNotifications
  autoload_dir(self, 'service_notifications')
  autoload_dir(self, 'service_notifications/actions')
  autoload_dir(self, 'service_notifications/models/active_record')

  # Channels
  module Adapters
    autoload_dir(self, 'service_notifications/adapters')
  end

  # Channels
  module Channels
    autoload_dir(self, 'service_notifications/channels')
  end

  # Contents
  module Contents
    autoload_dir(self, 'service_notifications/contents')
  end

  # Models
  module Models
    autoload_dir(self, 'service_notifications/models')
  end
end
