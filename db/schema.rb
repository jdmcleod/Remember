# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_23_203114) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "badges", force: :cascade do |t|
    t.string "name"
    t.string "icon_name"
    t.string "color"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_badges_on_user_id"
  end

  create_table "be_real_connections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status", default: 0
    t.string "session_info"
    t.string "bereal_access_token"
    t.string "firebase_refresh_token"
    t.string "firebase_id_token"
    t.string "token_type"
    t.datetime "expiration"
    t.string "uid"
    t.boolean "is_new_user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_be_real_connections_on_user_id"
  end

  create_table "be_real_memories", force: :cascade do |t|
    t.bigint "day_id", null: false
    t.boolean "late", default: false
    t.string "be_real_id"
    t.jsonb "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_id"], name: "index_be_real_memories_on_day_id"
  end

  create_table "day_badges", force: :cascade do |t|
    t.bigint "badge_id", null: false
    t.bigint "day_id", null: false
    t.index ["badge_id"], name: "index_day_badges_on_badge_id"
    t.index ["day_id"], name: "index_day_badges_on_day_id"
  end

  create_table "days", force: :cascade do |t|
    t.bigint "month_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["month_id"], name: "index_days_on_month_id"
  end

  create_table "entries", force: :cascade do |t|
    t.string "title"
    t.datetime "date"
    t.bigint "user_id"
    t.bigint "journalable_id"
    t.string "journalable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.tsvector "tsv"
    t.index ["tsv"], name: "index_entries_on_tsv", using: :gin
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.string "color"
    t.string "decorator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon_name"
    t.boolean "single_day", default: false
    t.boolean "secondary", default: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "months", force: :cascade do |t|
    t.bigint "quarter_id"
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quarter_id"], name: "index_months_on_quarter_id"
  end

  create_table "musings", force: :cascade do |t|
    t.string "name"
    t.string "kind", default: "generic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.datetime "date"
  end

  create_table "quarters", force: :cascade do |t|
    t.bigint "year_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year_id"], name: "index_quarters_on_year_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "profile_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone", default: "EST", null: false
    t.boolean "admin", default: false, null: false
  end

  create_table "years", force: :cascade do |t|
    t.bigint "user_id"
    t.string "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_years_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "badges", "users"
  add_foreign_key "be_real_connections", "users"
  add_foreign_key "be_real_memories", "days"
  add_foreign_key "day_badges", "badges"
  add_foreign_key "day_badges", "days"
  add_foreign_key "entries", "users"
  add_foreign_key "musings", "users"
end
