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

ActiveRecord::Schema[8.0].define(version: 2025_05_05_082851) do
  create_table "events", force: :cascade do |t|
    t.integer "merge_request_id"
    t.string "event_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "iid"
    t.string "actor"
    t.datetime "occured_at"
    t.integer "project_id"
    t.integer "note_id"
    t.index ["merge_request_id"], name: "index_events_on_merge_request_id"
    t.index ["note_id"], name: "index_events_on_note_id"
  end

  create_table "merge_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "iid"
    t.datetime "occured_at"
    t.string "actor"
    t.string "state"
    t.integer "project_id"
  end

  create_table "notes", force: :cascade do |t|
    t.integer "merge_request_id"
    t.integer "project_id"
    t.integer "iid"
    t.string "event"
    t.string "body"
    t.string "author"
    t.datetime "occured_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merge_request_id"], name: "index_notes_on_merge_request_id"
  end

  add_foreign_key "events", "merge_requests"
end
