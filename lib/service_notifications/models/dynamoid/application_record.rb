# frozen_string_literal: true

require 'dynamoid'

module ServiceNotifications
  # Abstract Model
  class ApplicationRecord
    def config=(config)
      @config = config
      self.config_id = config.id
    end

    def config
      @config ||= Config.find(config_id)
    end
  end
end