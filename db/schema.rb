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

ActiveRecord::Schema.define(version: 20160624063408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_translations", force: :cascade do |t|
    t.integer  "answer_id",  null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "text"
  end

  add_index "answer_translations", ["answer_id"], name: "index_answer_translations_on_answer_id", using: :btree
  add_index "answer_translations", ["locale"], name: "index_answer_translations_on_locale", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "candidate_id"
    t.integer  "question_id"
    t.string   "text"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "candidate_translations", force: :cascade do |t|
    t.integer  "candidate_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "bio"
  end

  add_index "candidate_translations", ["candidate_id"], name: "index_candidate_translations_on_candidate_id", using: :btree
  add_index "candidate_translations", ["locale"], name: "index_candidate_translations_on_locale", using: :btree

  create_table "candidates", force: :cascade do |t|
    t.integer  "contest_id"
    t.string   "photo"
    t.string   "name"
    t.text     "bio"
    t.string   "facebook"
    t.string   "website"
    t.string   "twitter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contest_translations", force: :cascade do |t|
    t.integer  "contest_id",  null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
    t.string   "title"
  end

  add_index "contest_translations", ["contest_id"], name: "index_contest_translations_on_contest_id", using: :btree
  add_index "contest_translations", ["locale"], name: "index_contest_translations_on_locale", using: :btree

  create_table "contests", force: :cascade do |t|
    t.integer  "guide_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "publish"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "endorsement_translations", force: :cascade do |t|
    t.integer  "endorsement_id", null: false
    t.string   "locale",         null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "endorser"
  end

  add_index "endorsement_translations", ["endorsement_id"], name: "index_endorsement_translations_on_endorsement_id", using: :btree
  add_index "endorsement_translations", ["locale"], name: "index_endorsement_translations_on_locale", using: :btree

  create_table "endorsements", force: :cascade do |t|
    t.integer  "endorsed_id"
    t.string   "endorsed_type"
    t.string   "endorser"
    t.integer  "stance",        default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "endorsements", ["endorsed_type", "endorsed_id"], name: "index_endorsements_on_endorsed_type_and_endorsed_id", using: :btree
  add_index "endorsements", ["stance"], name: "index_endorsements_on_stance", using: :btree

  create_table "field_translations", force: :cascade do |t|
    t.integer  "field_id",   null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "value"
  end

  add_index "field_translations", ["field_id"], name: "index_field_translations_on_field_id", using: :btree
  add_index "field_translations", ["locale"], name: "index_field_translations_on_locale", using: :btree

  create_table "fields", force: :cascade do |t|
    t.integer  "guide_id",       null: false
    t.text     "value"
    t.string   "field_template", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "fields", ["field_template"], name: "index_fields_on_field_template", using: :btree

  create_table "guides", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.date     "election_date"
  end

  create_table "languages", force: :cascade do |t|
    t.integer  "guide_id"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "guide_id"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.decimal  "lat"
    t.decimal  "lng"
    t.decimal  "west"
    t.decimal  "east"
    t.decimal  "north"
    t.decimal  "south"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "measure_translations", force: :cascade do |t|
    t.integer  "measure_id",  null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
    t.string   "title"
    t.text     "yes_means"
    t.text     "no_means"
  end

  add_index "measure_translations", ["locale"], name: "index_measure_translations_on_locale", using: :btree
  add_index "measure_translations", ["measure_id"], name: "index_measure_translations_on_measure_id", using: :btree

  create_table "measures", force: :cascade do |t|
    t.integer  "guide_id"
    t.string   "title"
    t.text     "description"
    t.text     "yes_means"
    t.text     "no_means"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "guide_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "question_translations", force: :cascade do |t|
    t.integer  "question_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "text"
  end

  add_index "question_translations", ["locale"], name: "index_question_translations_on_locale", using: :btree
  add_index "question_translations", ["question_id"], name: "index_question_translations_on_question_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "contest_id"
    t.string   "text"
    t.boolean  "publish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer  "tagged_id"
    t.string   "tagged_type"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree
  add_index "tags", ["tagged_type", "tagged_id"], name: "index_tags_on_tagged_type_and_tagged_id", using: :btree

  create_table "uploads", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "pic"
    t.boolean  "admin",                  default: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
