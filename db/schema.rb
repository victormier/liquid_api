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

ActiveRecord::Schema.define(version: 20170920163827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "body"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saltedge_accounts", force: :cascade do |t|
    t.integer "saltedge_login_id", null: false
    t.integer "user_id"
    t.string "saltedge_id"
    t.text "saltedge_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["saltedge_login_id"], name: "index_saltedge_accounts_on_saltedge_login_id", unique: true
    t.index ["user_id"], name: "index_saltedge_accounts_on_user_id"
  end

  create_table "saltedge_logins", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "saltedge_provider_id"
    t.string "saltedge_id"
    t.text "saltedge_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "virtual_accounts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.decimal "balance", default: "0.0"
    t.string "currency_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_virtual_accounts_on_user_id"
  end

end
