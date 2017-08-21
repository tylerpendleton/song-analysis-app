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

ActiveRecord::Schema.define(version: 20170820195804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.string   "genres",       default: [],              array: true
    t.string   "spotify_id"
    t.string   "image_large"
    t.string   "image_medium"
    t.string   "image_small"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "song_sections", force: :cascade do |t|
    t.string   "section"
    t.text     "lyrics"
    t.string   "instrumentation",   default: [],              array: true
    t.integer  "song_structure_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "song_structures", force: :cascade do |t|
    t.integer  "song_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string   "title"
    t.float    "duration_ms"
    t.integer  "key"
    t.integer  "tempo"
    t.integer  "time_signature"
    t.integer  "integer"
    t.boolean  "explicit"
    t.string   "copyright_text"
    t.string   "copyright_type"
    t.string   "label",          default: [],              array: true
    t.string   "uri"
    t.string   "string"
    t.integer  "spotify_id"
    t.integer  "artist_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "user_auths", force: :cascade do |t|
    t.string   "access_token"
    t.string   "token_type"
    t.string   "token_scope"
    t.integer  "expires_in"
    t.string   "refresh_token"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
