# frozen_string_literal: true

module ServiceNotifications
  # A Post made to a third party service
  class Post < ApplicationRecord
    include Models::Post

    self.table_name = 'service_notifications_posts'

    serialize :data, Hash
    serialize :response, Hash

    #
    # Associations
    #

    belongs_to :request, dependent: :destroy, inverse_of: :posts

    #
    # Validate
    #

    validates :request_id, presence: true

    #
    # Scopes
    #

    scope :unprocessed, -> { where(processed_at: nil) }
    scope :processed, -> { where.not(processed_at: nil) }
    scope :kind, ->(kind) { where(kind: kind) }

    #
    # Instance Methods
    #

    def templates
      request.templates.where(channel: kind)
    end
  end
end