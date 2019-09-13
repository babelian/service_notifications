# frozen_string_literal: true

module ServiceNotifications
  # Template loader
  class Template < ApplicationRecord
    include Models::Template

    self.table_name = 'service_notifications_templates'

    #
    # Associations
    #

    belongs_to :config

    #
    # Validations
    #

    validates :config, :version, :notification, :channel, :format, presence: true
  end
end