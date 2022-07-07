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

ActiveRecord::Schema[7.0].define(version: 2022_06_23_161442) do
  create_table "colors", force: :cascade do |t|
    t.string "hex"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colors_palettes", id: false, force: :cascade do |t|
    t.integer "color_id", null: false
    t.integer "palette_id", null: false
  end

  create_table "colors_tags", id: false, force: :cascade do |t|
    t.integer "color_id", null: false
    t.integer "tag_id", null: false
  end

  create_table "palettes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "palettes_tags", id: false, force: :cascade do |t|
    t.integer "palette_id", null: false
    t.integer "tag_id", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
