# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_18_013723) do

  create_table "listings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "price", null: false
    t.integer "location", null: false
    t.integer "amount", default: 1
    t.integer "state", default: 0
    t.datetime "start_time"
    t.datetime "end_time"
    t.text "description"
    t.integer "buyer"
    t.datetime "reserved_time"
    t.integer "reserved_amount"
    t.boolean "completed", default: false
    t.index ["price"], name: "index_listings_on_price"
    t.index ["user_id"], name: "index_listings_on_user_id"
    t.index ["user_id"], name: "index_listings_on_user_id_and_name"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.boolean "cash", default: false
    t.boolean "venmo", default: false
    t.boolean "paypal", default: false
    t.boolean "cashapp", default: false
    t.string "contact"
    t.float "rating"
    t.integer "rating_count", default: 0
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "listings", "users"
end
