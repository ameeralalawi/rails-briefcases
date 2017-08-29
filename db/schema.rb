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

ActiveRecord::Schema.define(version: 20170823100658) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cases", force: :cascade do |t|
    t.string "status"
    t.string "user_input_text"
    t.string "user_output_text"
    t.string "name"
    t.string "icon"
    t.string "color"
    t.string "scenario_a"
    t.string "scenario_b"
    t.boolean "output_pref_1"
    t.boolean "output_pref_2"
    t.boolean "output_pref_3"
    t.boolean "output_pref_4"
    t.boolean "output_pref_5"
    t.boolean "output_pref_6"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cases_on_user_id"
  end

  create_table "leads", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.bigint "case_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_leads_on_case_id"
  end

  create_table "lines", force: :cascade do |t|
    t.string "name"
    t.string "scenario"
    t.string "category"
    t.string "recurrence"
    t.date "start_date"
    t.date "end_date"
    t.bigint "variable_id"
    t.bigint "case_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "escalator"
    t.index ["case_id"], name: "index_lines_on_case_id"
    t.index ["variable_id"], name: "index_lines_on_variable_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "provider"
    t.string "uid"
    t.string "facebook_picture_url"
    t.string "first_name"
    t.string "last_name"
    t.string "token"
    t.datetime "token_expiry"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variable_uses", force: :cascade do |t|
    t.float "value"
    t.bigint "lead_id"
    t.bigint "variable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lead_id"], name: "index_variable_uses_on_lead_id"
    t.index ["variable_id"], name: "index_variable_uses_on_variable_id"
  end

  create_table "variables", force: :cascade do |t|
    t.string "expression"
    t.string "name"
    t.float "expert_value"
    t.bigint "case_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["case_id"], name: "index_variables_on_case_id"
  end

  add_foreign_key "cases", "users"
  add_foreign_key "leads", "cases"
  add_foreign_key "lines", "cases"
  add_foreign_key "lines", "variables"
  add_foreign_key "variable_uses", "leads"
  add_foreign_key "variable_uses", "variables"
  add_foreign_key "variables", "cases"
end
