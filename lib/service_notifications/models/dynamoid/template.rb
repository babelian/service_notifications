# frozen_string_literal: true

module ServiceNotifications
  # Template loader
  class Template < ApplicationRecord
    include Dynamoid::Document
    include Models::Template

    table name: :service_notification_templates, key: :id

    field :config_id, :string
    field :version, :string
    field :notification, :string
    field :channel, :string
    field :format, :string
    field :data, :raw

    global_secondary_index hash_key: :config_id

    #
    # Associations
    #

    # belongs_to :config, class: Config

    #
    # Validations
    #

    validates :config, :version, :notification, :channel, :format, presence: true
  end
end