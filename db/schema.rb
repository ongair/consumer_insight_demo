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

ActiveRecord::Schema.define(version: 20160222133231) do

  create_table "options", force: true do |t|
    t.text     "text"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "options", ["question_id"], name: "index_options_on_question_id"

  create_table "progresses", force: true do |t|
    t.integer  "step_id"
    t.integer  "reviewer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "progresses", ["reviewer_id"], name: "index_progresses_on_reviewer_id"
  add_index "progresses", ["step_id"], name: "index_progresses_on_step_id"

  create_table "questions", force: true do |t|
    t.text     "text"
    t.integer  "step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["step_id"], name: "index_questions_on_step_id"

  create_table "reviewers", force: true do |t|
    t.string   "name"
    t.string   "telegram_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "steps", force: true do |t|
    t.string   "name"
    t.string   "step_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wizard_id"
  end

  add_index "steps", ["wizard_id"], name: "index_steps_on_wizard_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "wizards", force: true do |t|
    t.string   "name"
    t.string   "start_keyword"
    t.string   "reset_keyword"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
