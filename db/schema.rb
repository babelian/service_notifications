# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_01_10_204821) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0
    t.integer "attempts", default: 0
    t.text "handler"
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unique_key", limit: 255
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "service_notifications_configs", force: :cascade do |t|
    t.string "api_key", limit: 32
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["api_key"], name: "index_service_notifications_configs_on_unique", unique: true
  end

  create_table "service_notifications_posts", force: :cascade do |t|
    t.integer "request_id"
    t.string "kind"
    t.string "uid"
    t.text "data"
    t.text "response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "processed_at"
    t.index ["request_id", "kind", "uid"], name: "index_service_notifications_posts_on_unique", unique: true
  end

  create_table "service_notifications_requests", force: :cascade do |t|
    t.integer "config_id"
    t.string "notification"
    t.text "data"
    t.string "unique_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "processed_at"
    t.index ["config_id"], name: "index_service_notifications_requests_on_config_id"
    t.index ["unique_key"], name: "index_service_notifications_requests_on_unique_key", unique: true
  end

  create_table "service_notifications_templates", force: :cascade do |t|
    t.integer "config_id"
    t.string "version"
    t.string "notification"
    t.string "channel"
    t.string "format"
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["config_id"], name: "index_service_notifications_templates_on_config_id"
  end

end
