# frozen_string_literal: true

require 'delayed_job_active_record'
require 'service_operation'

module ServiceNotifications
  # @abstract
  class Action
    include ServiceOperation::Base
  end
end