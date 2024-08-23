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

ActiveRecord::Schema[7.2].define(version: 2024_02_29_230000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_fields", force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.string "customizable_type", null: false
    t.jsonb "default_value_meta", default: {}, null: false
    t.jsonb "options", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customizable_type"], name: "index_active_fields_on_customizable_type"
    t.index ["name", "customizable_type"], name: "index_active_fields_on_name_and_customizable_type", unique: true
  end

  create_table "active_fields_values", force: :cascade do |t|
    t.string "customizable_type", null: false
    t.bigint "customizable_id", null: false
    t.bigint "active_field_id", null: false
    t.jsonb "value_meta", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_field_id"], name: "index_active_fields_values_on_active_field_id"
    t.index ["customizable_type", "customizable_id", "active_field_id"], name: "index_active_fields_values_on_customizable_and_field", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_authors_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_posts_on_author_id"
  end

  add_foreign_key "active_fields_values", "active_fields", name: "active_fields_values_active_field_id_fk"
end
