# frozen_string_literal: true

require 'securerandom'

module ServiceNotifications
  # Configuration for a client
  class Config < ApplicationRecord
    include Dynamoid::Document
    include Models::Config

    table name: :service_notification_configs, key: :id

    field :api_key, :string
    field :data, :raw

    #
    # Associations
    #

    has_many :templates, class: Template
    has_many :requests, class: Request

    validates :api_key, presence: true
  end
end