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

ActiveRecord::Schema.define(version: 20171201092457) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rules", force: :cascade do |t|
    t.integer "user_id"
    t.integer "virtual_account_id"
    t.text "config"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: false
    t.index ["user_id"], name: "index_rules_on_user_id"
  end

  create_table "saltedge_accounts", force: :cascade do |t|
    t.integer "saltedge_login_id", null: false
    t.integer "user_id"
    t.string "saltedge_id"
    t.text "saltedge_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "selected", default: false
    t.index ["saltedge_id"], name: "index_saltedge_accounts_on_saltedge_id", unique: true
    t.index ["saltedge_login_id"], name: "index_saltedge_accounts_on_saltedge_login_id"
    t.index ["user_id"], name: "index_saltedge_accounts_on_user_id"
  end

  create_table "saltedge_logins", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "saltedge_provider_id"
    t.string "saltedge_id"
    t.text "saltedge_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "killed", default: false
    t.datetime "last_refresh_requested_at"
    t.index ["saltedge_provider_id"], name: "index_saltedge_logins_on_saltedge_provider_id"
    t.index ["user_id"], name: "index_saltedge_logins_on_user_id"
  end

  create_table "saltedge_providers", force: :cascade do |t|
    t.integer "saltedge_id"
    t.text "saltedge_data"
    t.string "status"
    t.string "mode"
    t.string "name"
    t.boolean "automatic_fetch"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saltedge_transactions", force: :cascade do |t|
    t.integer "saltedge_account_id"
    t.string "saltedge_id"
    t.string "status"
    t.date "made_on"
    t.decimal "amount"
    t.string "currency_code"
    t.string "category"
    t.text "saltedge_data"
    t.datetime "saltedge_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["saltedge_account_id"], name: "index_saltedge_transactions_on_saltedge_account_id"
    t.index ["saltedge_id"], name: "index_saltedge_transactions_on_saltedge_id", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.string "type"
    t.integer "virtual_account_id"
    t.integer "related_virtual_account_id"
    t.integer "saltedge_transaction_id"
    t.integer "virtual_transaction_id"
    t.decimal "amount"
    t.datetime "made_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rule_id"
    t.string "saltedge_id"
    t.string "custom_category"
    t.index ["made_on", "saltedge_id"], name: "index_transactions_on_made_on_and_saltedge_id", order: { made_on: :desc, saltedge_id: :desc }
    t.index ["related_virtual_account_id"], name: "index_transactions_on_related_virtual_account_id"
    t.index ["rule_id"], name: "index_transactions_on_rule_id"
    t.index ["saltedge_transaction_id"], name: "index_transactions_on_saltedge_transaction_id"
    t.index ["virtual_account_id"], name: "index_transactions_on_virtual_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_generated_at"
    t.string "saltedge_id"
    t.string "saltedge_custom_identifier"
    t.string "saltedge_customer_secret"
    t.datetime "will_be_removed_at"
  end

  create_table "virtual_accounts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.decimal "balance", default: "0.0"
    t.string "currency_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "saltedge_account_id"
    t.index ["saltedge_account_id"], name: "index_virtual_accounts_on_saltedge_account_id", unique: true
    t.index ["user_id"], name: "index_virtual_accounts_on_user_id"
  end

  add_foreign_key "rules", "users", on_delete: :cascade
  add_foreign_key "saltedge_accounts", "saltedge_logins", on_delete: :cascade
  add_foreign_key "saltedge_accounts", "users", on_delete: :cascade
  add_foreign_key "saltedge_logins", "users", on_delete: :cascade
  add_foreign_key "saltedge_transactions", "saltedge_accounts", on_delete: :cascade
  add_foreign_key "transactions", "saltedge_transactions", on_delete: :cascade
  add_foreign_key "transactions", "virtual_accounts", column: "related_virtual_account_id"
  add_foreign_key "transactions", "virtual_accounts", on_delete: :cascade
  add_foreign_key "virtual_accounts", "saltedge_accounts", on_delete: :cascade
  add_foreign_key "virtual_accounts", "users", on_delete: :cascade
end
