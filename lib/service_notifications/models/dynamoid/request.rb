# frozen_string_literal: true

module ServiceNotifications
  # A Request to make one or more {Post} calls
  class Request < ApplicationRecord
    include Dynamoid::Document
    include Models::Request

    table name: :service_notification_requests, key: :id

    field :config_id, :string
    field :notification, :string
    field :data, :raw
    field :unique_key, :string
    field :processed_at, :datetime

    global_secondary_index hash_key: :config_id

    #
    # Associations
    #

    # belongs_to :config, class: Config, foreign_key: :config_id
    has_many :posts, class: Post

    #
    # Validations
    #

    validates :config_id, :notification, presence: true

    #
    # Instance Methods
    #

    def unprocessed_posts
      Post.where(request_id: id).consistent.reject(&:processed_at)
    end

    def templates
      Template.where(config_id: config.id, version: template_version, notification: notification)
    end
  end
end