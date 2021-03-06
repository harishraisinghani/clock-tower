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

ActiveRecord::Schema.define(version: 20160727183642) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_keys", force: :cascade do |t|
    t.string   "key",                        null: false
    t.integer  "user_id",                    null: false
    t.string   "note",          default: "", null: false
    t.datetime "last_accessed"
    t.string   "last_ip",       default: "", null: false
    t.datetime "revoked_on"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "availabilities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "day_of_week", default: 0, null: false
    t.string   "start_time"
    t.string   "end_time"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "availabilities", ["user_id"], name: "index_availabilities_on_user_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string  "name"
    t.string  "province"
    t.decimal "tax_percent", precision: 5, scale: 3
    t.string  "tax_name"
    t.string  "user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.string   "accounting_code",             default: "", null: false
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "rates", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "task_id"
    t.integer  "user_id"
    t.decimal  "rate",       precision: 5, scale: 2, null: false
    t.string   "note",                               null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "statement_periods", force: :cascade do |t|
    t.string  "from"
    t.string  "to"
    t.integer "draft_days"
  end

  create_table "statement_time_entries", force: :cascade do |t|
    t.integer "statement_id",  null: false
    t.integer "time_entry_id", null: false
    t.string  "state"
  end

  create_table "statement_transitions", force: :cascade do |t|
    t.string   "to_state",                    null: false
    t.text     "metadata",     default: "{}"
    t.integer  "sort_key",                    null: false
    t.integer  "statement_id",                null: false
    t.boolean  "most_recent",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "statement_transitions", ["statement_id", "most_recent"], name: "index_statement_transitions_parent_most_recent", unique: true, where: "most_recent", using: :btree
  add_index "statement_transitions", ["statement_id", "sort_key"], name: "index_statement_transitions_parent_sort", unique: true, using: :btree

  create_table "statements", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "from"
    t.datetime "to"
    t.datetime "post_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "locked_at"
    t.datetime "void_at"
    t.datetime "paid_at"
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "apply_secondary_rate"
    t.string   "accounting_code",                  default: "", null: false
  end

  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "time_entries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "task_id"
    t.date     "entry_date"
    t.decimal  "duration_in_hours",                   precision: 5, scale: 2
    t.string   "comments",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",                                precision: 5, scale: 2
    t.boolean  "apply_rate"
    t.boolean  "is_holiday"
    t.decimal  "holiday_rate_multiplier",             precision: 4, scale: 2
    t.boolean  "legacy"
    t.string   "holiday_code"
    t.boolean  "has_tax"
    t.string   "tax_desc"
    t.decimal  "tax_percent",                         precision: 5, scale: 3
    t.integer  "location_id"
    t.integer  "source_rate_id"
  end

  add_index "time_entries", ["entry_date"], name: "index_time_entries_on_entry_date", using: :btree
  add_index "time_entries", ["project_id"], name: "index_time_entries_on_project_id", using: :btree
  add_index "time_entries", ["task_id"], name: "index_time_entries_on_task_id", using: :btree
  add_index "time_entries", ["user_id"], name: "index_time_entries_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "firstname",               limit: 255
    t.string   "lastname",                limit: 255
    t.string   "email",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest",         limit: 255
    t.boolean  "is_admin"
    t.boolean  "active"
    t.boolean  "hourly",                                                      default: true
    t.decimal  "rate",                                precision: 5, scale: 2
    t.decimal  "secondary_rate",                      precision: 5, scale: 2
    t.decimal  "holiday_rate_multiplier",             precision: 4, scale: 2, default: 1.5
    t.boolean  "password_reset_required"
    t.string   "company_name",            limit: 255
    t.string   "password_reset_token"
    t.string   "tax_number"
    t.integer  "location_id"
    t.boolean  "has_tax"
    t.boolean  "receive_admin_email",                                         default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "vacations", force: :cascade do |t|
    t.integer  "user_id",                  null: false
    t.integer  "approver_id"
    t.date     "start_date",               null: false
    t.date     "end_date",                 null: false
    t.string   "note",        default: "", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "vacations", ["approver_id"], name: "index_vacations_on_approver_id", using: :btree
  add_index "vacations", ["user_id"], name: "index_vacations_on_user_id", using: :btree

end
