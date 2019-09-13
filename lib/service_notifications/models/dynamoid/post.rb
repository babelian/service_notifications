# frozen_string_literal: true

module ServiceNotifications
  # A Post made to a third party service
  class Post < ApplicationRecord
    include Dynamoid::Document
    include Models::Post

    table name: :service_notification_posts, key: :id

    field :request_id, :string
    field :kind, :string
    field :uid, :string
    field :data, :raw
    field :response, :raw
    field :processed_at, :datetime

    global_secondary_index hash_key: :request_id

    #
    # Associations
    #

    # belongs_to :request, class: Request, foreign_key: :request_id

    def request
      @request ||= Request.find request_id
    end

    def request=(request)
      @request = request
      self.request_id = request.id
    end

    #
    # Validate
    #

    validates :request_id, presence: true

    #
    # Instance Methods
    #

    def templates
      request.templates.where(channel: kind)
    end
  end
end