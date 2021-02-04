# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_210_109_154_704) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'account_users', force: :cascade do |t|
    t.bigint 'account_id'
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_id'], name: 'index_account_users_on_account_id'
    t.index ['user_id'], name: 'index_account_users_on_user_id'
  end

  create_table 'accounts', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'archives', force: :cascade do |t|
    t.string 'filename'
    t.string 'extension'
    t.string 'md5'
    t.integer 'size'
    t.string 'owner_type'
    t.bigint 'owner_id'
    t.text 'content'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['extension'], name: 'index_archives_on_extension'
    t.index ['filename'], name: 'index_archives_on_filename'
    t.index ['md5'], name: 'index_archives_on_md5'
    t.index %w[owner_type owner_id], name: 'index_archives_on_owner_type_and_owner_id'
    t.index ['size'], name: 'index_archives_on_size'
  end

  create_table 'associated_labels', force: :cascade do |t|
    t.string 'owner_type'
    t.bigint 'owner_id'
    t.bigint 'label_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['label_id'], name: 'index_associated_labels_on_label_id'
    t.index %w[owner_type owner_id], name: 'index_associated_labels_on_owner_type_and_owner_id'
  end

  create_table 'bam_accounts', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.jsonb 'fields', default: []
    t.string 'account_type'
    t.bigint 'account_user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_user_id'], name: 'index_bam_accounts_on_account_user_id'
  end

  create_table 'bam_categories', force: :cascade do |t|
    t.string 'name'
    t.string 'level'
    t.string 'description'
    t.bigint 'account_user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[account_user_id name], name: 'index_bam_categories_on_account_user_id_and_name', unique: true
    t.index ['account_user_id'], name: 'index_bam_categories_on_account_user_id'
  end

  create_table 'bam_items', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.bigint 'account_user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_user_id'], name: 'index_bam_items_on_account_user_id'
  end

  create_table 'bam_transactions', force: :cascade do |t|
    t.integer 'price_cents', default: 0
    t.float 'amount', default: 0.0
    t.string 'origin'
    t.string 'status'
    t.string 'description'
    t.text 'annotation'
    t.date 'transacted_at'
    t.date 'paid_at'
    t.boolean 'ignore', default: false
    t.boolean 'boolean', default: false
    t.bigint 'bam_item_id'
    t.bigint 'bam_category_id'
    t.bigint 'bam_account_id'
    t.bigint 'account_user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_user_id'], name: 'index_bam_transactions_on_account_user_id'
    t.index ['bam_account_id'], name: 'index_bam_transactions_on_bam_account_id'
    t.index ['bam_category_id'], name: 'index_bam_transactions_on_bam_category_id'
    t.index ['bam_item_id'], name: 'index_bam_transactions_on_bam_item_id'
  end

  create_table 'events', force: :cascade do |t|
    t.bigint 'account_user_id'
    t.string 'app'
    t.string 'service'
    t.string 'message'
    t.string 'event_type'
    t.string 'origin'
    t.string 'action'
    t.string 'user_email'
    t.boolean 'important', default: false
    t.jsonb 'details', default: {}
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[account_user_id app], name: 'index_events_on_account_user_id_and_app'
    t.index %w[account_user_id important], name: 'index_events_on_account_user_id_and_important'
    t.index %w[account_user_id user_email], name: 'index_events_on_account_user_id_and_user_email'
    t.index ['account_user_id'], name: 'index_events_on_account_user_id'
  end

  create_table 'labels', force: :cascade do |t|
    t.string 'name'
    t.string 'original_name'
    t.string 'app'
    t.string 'color'
    t.string 'background_color'
    t.bigint 'account_user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[account_user_id app name], name: 'index_labels_on_account_user_id_and_app_and_name'
    t.index ['account_user_id'], name: 'index_labels_on_account_user_id'
  end

  create_table 'moment_photos', force: :cascade do |t|
    t.string 'description'
    t.jsonb 'metadata', default: {}
    t.bigint 'account_user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_user_id'], name: 'index_moment_photos_on_account_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'provider', default: 'email', null: false
    t.string 'uid', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.boolean 'allow_password_change', default: false
    t.datetime 'remember_created_at'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.string 'name'
    t.string 'nickname'
    t.string 'image'
    t.string 'email'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.inet 'current_sign_in_ip'
    t.inet 'last_sign_in_ip'
    t.json 'tokens'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index %w[uid provider], name: 'index_users_on_uid_and_provider', unique: true
  end

  add_foreign_key 'account_users', 'accounts'
  add_foreign_key 'account_users', 'users'
  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'associated_labels', 'labels'
  add_foreign_key 'bam_accounts', 'account_users'
  add_foreign_key 'bam_categories', 'account_users'
  add_foreign_key 'bam_items', 'account_users'
  add_foreign_key 'bam_transactions', 'account_users'
  add_foreign_key 'bam_transactions', 'bam_accounts'
  add_foreign_key 'labels', 'account_users'
  add_foreign_key 'moment_photos', 'account_users'
end
