# frozen_string_literal: true

module ServiceNotifications
  # A Request to make one or more {Post} calls
  class Request < ApplicationRecord
    include Models::Request

    self.table_name = 'service_notifications_requests'

    serialize :data, Hash

    #
    # Associations
    #

    belongs_to :config, inverse_of: :requests
    has_many :posts, inverse_of: :request

    #
    # Validations
    #

    validates :config_id, :notification, presence: true

    #
    # Instance Methods
    #

    def templates
      config.templates.where(version: template_version, notification: notification)
    end

    def unprocessed_posts
      posts.unprocessed
    end
  end
end