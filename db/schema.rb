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

ActiveRecord::Schema.define(version: 20150426125957) do

  create_table "accounts", force: :cascade do |t|
    t.string   "domain"
    t.string   "password"
    t.integer  "insales_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "walletone_shop_id"
    t.string   "walletone_password"
    t.integer  "walletone_currency"
    t.integer  "payment_gateway_id"
  end

  add_index "accounts", ["domain"], name: "index_accounts_on_domain", unique: true

  create_table "payments", force: :cascade do |t|
    t.string   "shop_id",                    null: false
    t.float    "amount",                     null: false
    t.integer  "transaction_id",             null: false
    t.text     "description"
    t.string   "key",                        null: false
    t.integer  "order_id",                   null: false
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "status",         default: 0
  end

  add_index "payments", ["transaction_id"], name: "index_payments_on_transaction_id", unique: true

end
