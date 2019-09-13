# Add Tables
class AddTables < ActiveRecord::Migration[5.2]
  def change
    create_table :delayed_jobs, :force => true do |table|
      table.integer  :priority, :default => 0      # Allows some jobs to jump to the front of the queue
      table.integer  :attempts, :default => 0      # Provides for retries, but still fail eventually.
      table.text     :handler                      # YAML-encoded string of the object that will do work
      table.text     :last_error                   # reason for last failure (See Note below)
      table.datetime :run_at                       # When to run. Could be Time.zone.now for immediately, or sometime in the future.
      table.datetime :locked_at                    # Set when a client is working on this object
      table.datetime :failed_at                    # Set when all retries have failed (actually, by default, the record is deleted instead)
      table.string   :locked_by                    # Who is working on this object (if locked)
      table.string   :queue                        # The name of the queue this job is in
      table.timestamps
      table.string :unique_key, limit: 255
      table.index [:priority, :run_at], name: 'delayed_jobs_priority'
    end

    create_table 'service_notifications_configs', force: :cascade do |t|
      t.string :api_key, limit: 32
      t.text :data
      t.datetime :created_at
      t.datetime :updated_at
      t.index [:api_key], name: 'index_service_notifications_configs_on_unique', unique: true
    end

    create_table 'service_notifications_templates', force: :cascade do |t|
      t.integer :config_id
      t.string :version
      t.string :notification
      t.string :channel
      t.string :format
      t.text :data
      t.datetime :created_at
      t.datetime :updated_at
      t.index [:config_id], name: 'index_service_notifications_templates_on_config_id'
    end

    create_table 'service_notifications_requests', force: :cascade do |t|
      t.integer :config_id
      t.string :notification
      t.text :data
      t.string :unique_key
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :processed_at
      t.index [:config_id], name: 'index_service_notifications_requests_on_config_id'
      t.index [:unique_key], name: 'index_service_notifications_requests_on_unique_key', unique: true
    end

    create_table 'service_notifications_posts', force: :cascade do |t|
      t.integer :request_id
      t.string :kind
      t.string :uid
      t.text :data
      t.text :response
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :processed_at
      t.index [:request_id, :kind, :uid], name: 'index_service_notifications_posts_on_unique', unique: true
    end
  end
end
