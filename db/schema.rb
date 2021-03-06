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

ActiveRecord::Schema.define(version: 20150430185520) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "email",         limit: 256
    t.string   "password_hash", limit: 64
    t.string   "salt",          limit: 36
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "uuid",          limit: 36
  end

  add_index "accounts", ["uuid"], name: "index_accounts_on_uuid", unique: true, using: :btree

  create_table "api_keys", force: :cascade do |t|
    t.string   "key",        limit: 36
    t.integer  "account_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "api_keys", ["account_id"], name: "index_api_keys_on_account_id", using: :btree
  add_index "api_keys", ["key"], name: "index_api_keys_on_key", unique: true, using: :btree

  create_table "schemas", force: :cascade do |t|
    t.string   "name",       limit: 64
    t.string   "uuid",       limit: 36
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "account_id"
  end

  add_index "schemas", ["account_id"], name: "index_schemas_on_account_id", using: :btree
  add_index "schemas", ["uuid"], name: "index_schemas_on_uuid", unique: true, using: :btree

  add_foreign_key "schemas", "accounts"
end
