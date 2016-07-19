# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160719103931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "code_tables", force: :cascade do |t|
    t.string   "type"
    t.integer  "code"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meal_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "menu_name"
    t.integer  "price"
    t.datetime "meal_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "meal_logs", ["user_id"], name: "index_meal_logs_on_user_id", using: :btree

  create_table "meal_meet_up_logs", force: :cascade do |t|
    t.integer  "meal_meet_up_id"
    t.string   "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "meal_meet_up_logs", ["meal_meet_up_id"], name: "index_meal_meet_up_logs_on_meal_meet_up_id", using: :btree

  create_table "meal_meet_up_tasks", force: :cascade do |t|
    t.integer  "meal_log_id"
    t.integer  "meal_meet_up_id"
    t.integer  "task_status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "meal_meet_up_tasks", ["meal_log_id"], name: "index_meal_meet_up_tasks_on_meal_log_id", using: :btree
  add_index "meal_meet_up_tasks", ["meal_meet_up_id"], name: "index_meal_meet_up_tasks_on_meal_meet_up_id", using: :btree

  create_table "meal_meet_ups", force: :cascade do |t|
    t.integer  "total_price"
    t.integer  "messenger_code"
    t.string   "messenger_room_id"
    t.integer  "admin_id"
    t.integer  "meetup_status"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "user_messengers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "messenger_code"
    t.string   "messenger_user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "user_messengers", ["user_id"], name: "index_user_messengers_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "meal_meet_up_tasks", "code_tables", column: "task_status"
  add_foreign_key "meal_meet_ups", "code_tables", column: "meetup_status"
  add_foreign_key "meal_meet_ups", "code_tables", column: "messenger_code"
  add_foreign_key "meal_meet_ups", "users", column: "admin_id"
  add_foreign_key "user_messengers", "code_tables", column: "messenger_code"
end
