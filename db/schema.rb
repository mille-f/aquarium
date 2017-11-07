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

ActiveRecord::Schema.define(version: 20171107162559) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "alkalis", force: :cascade do |t|
    t.string   "ent",        limit: 255
    t.string   "att",        limit: 255
    t.string   "val",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "cs1s", id: false, force: :cascade do |t|
    t.string "ent", limit: 255
    t.string "att", limit: 255
    t.string "val", limit: 255
  end

  create_table "keyword_periodic_tables", id: false, force: :cascade do |t|
    t.string  "keyword", limit: 255
    t.integer "start",   limit: 4
    t.integer "end",     limit: 4
    t.boolean "watch",   limit: 1
  end

  create_table "ohenros", id: false, force: :cascade do |t|
    t.string "ent", limit: 255
    t.string "att", limit: 255
    t.string "val", limit: 255
  end

  create_table "periodic_tables", id: false, force: :cascade do |t|
    t.string "ent", limit: 255
    t.string "att", limit: 255
    t.string "val", limit: 255
  end

  create_table "question_alkalis", id: false, force: :cascade do |t|
    t.string  "question",    limit: 255
    t.string  "correct",     limit: 255
    t.string  "wrong1",      limit: 255
    t.string  "wrong2",      limit: 255
    t.string  "wrong3",      limit: 255
    t.integer "author_id",   limit: 4
    t.string  "author_name", limit: 255
  end

  create_table "question_cs1s", id: false, force: :cascade do |t|
    t.string  "question",    limit: 255
    t.string  "correct",     limit: 255
    t.string  "wrong1",      limit: 255
    t.string  "wrong2",      limit: 255
    t.string  "wrong3",      limit: 255
    t.integer "author_id",   limit: 4
    t.string  "author_name", limit: 255
  end

  create_table "question_ohenros", id: false, force: :cascade do |t|
    t.string  "question",    limit: 255
    t.string  "correct",     limit: 255
    t.string  "wrong1",      limit: 255
    t.string  "wrong2",      limit: 255
    t.string  "wrong3",      limit: 255
    t.integer "author_id",   limit: 4
    t.string  "author_name", limit: 255
  end

  create_table "test1_alkalis", force: :cascade do |t|
    t.string   "ent",        limit: 255
    t.string   "att",        limit: 255
    t.string   "val",        limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "state",      limit: 4,   default: 0
  end

  create_table "test1_cs1s", id: false, force: :cascade do |t|
    t.string  "ent",   limit: 255
    t.string  "att",   limit: 255
    t.string  "val",   limit: 255
    t.integer "state", limit: 4,   default: 0
  end

  create_table "test1_ohenros", id: false, force: :cascade do |t|
    t.string  "ent",   limit: 255
    t.string  "att",   limit: 255
    t.string  "val",   limit: 255
    t.integer "state", limit: 4,   default: 0
  end

  create_table "test1_periodic_tables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test2_alkalis", force: :cascade do |t|
    t.string   "ent",        limit: 255
    t.string   "att",        limit: 255
    t.string   "val",        limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "state",      limit: 4,   default: 0
  end

  create_table "testcases", force: :cascade do |t|
    t.string   "entity",     limit: 255
    t.string   "attribute",  limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "username",               limit: 255
    t.integer  "role",                   limit: 4,   default: 0
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
