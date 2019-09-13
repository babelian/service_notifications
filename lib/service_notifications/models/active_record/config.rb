# frozen_string_literal: true

require 'securerandom'

module ServiceNotifications
  # Configuration for a client
  class Config < ApplicationRecord
    include Models::Config

    self.table_name = 'service_notifications_configs'

    serialize :data, Hash

    #
    # Associations
    #

    has_many :templates, inverse_of: :config, dependent: :destroy
    has_many :requests, inverse_of: :config

    #
    # Validations
    #

    validates :api_key, presence: true
  end
end