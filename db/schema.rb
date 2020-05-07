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

ActiveRecord::Schema.define(version: 2020_03_26_001149) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_users", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_users_on_account_id"
    t.index ["user_id"], name: "index_account_users_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.bigint "account_user_id"
    t.string "rsb_module"
    t.string "service"
    t.string "message"
    t.string "event_type"
    t.string "origin"
    t.string "action"
    t.boolean "important", default: false
    t.jsonb "details", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_user_id"], name: "index_events_on_account_user_id"
  end

  create_table "ma_accounts", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "account_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_user_id"], name: "index_ma_accounts_on_account_user_id"
  end

  create_table "ma_items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "account_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_user_id"], name: "index_ma_items_on_account_user_id"
  end

  create_table "ma_subitems", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "ma_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ma_item_id"], name: "index_ma_subitems_on_ma_item_id"
  end

  create_table "ma_transactions", force: :cascade do |t|
    t.string "description"
    t.integer "price_cents", default: 0
    t.float "amount", default: 0.0
    t.string "origin"
    t.string "status"
    t.date "transaction_date"
    t.date "pay_date"
    t.bigint "ma_item_id"
    t.bigint "ma_subitem_id"
    t.bigint "ma_account_id"
    t.bigint "account_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_user_id"], name: "index_ma_transactions_on_account_user_id"
    t.index ["ma_account_id"], name: "index_ma_transactions_on_ma_account_id"
    t.index ["ma_item_id"], name: "index_ma_transactions_on_ma_item_id"
    t.index ["ma_subitem_id"], name: "index_ma_transactions_on_ma_subitem_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "account_users", "accounts"
  add_foreign_key "account_users", "users"
  add_foreign_key "events", "account_users"
  add_foreign_key "ma_accounts", "account_users"
  add_foreign_key "ma_items", "account_users"
  add_foreign_key "ma_subitems", "ma_items"
  add_foreign_key "ma_transactions", "account_users"
  add_foreign_key "ma_transactions", "ma_accounts"
end
