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

ActiveRecord::Schema.define(version: 20131219175008) do

  create_table "episode_data", force: true do |t|
    t.integer "episode_id"
    t.integer "current_position", default: 0
    t.boolean "is_played"
  end

  create_table "episodes", force: true do |t|
    t.string   "title"
    t.string   "audio_url"
    t.string   "link_url"
    t.string   "guid"
    t.text     "description"
    t.datetime "publication_date"
    t.integer  "podcast_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration"
  end

  add_index "episodes", ["podcast_id"], name: "index_episodes_on_podcast_id"

  create_table "podcasts", force: true do |t|
    t.string   "title"
    t.string   "image_url"
    t.string   "feed_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "queued_episodes", force: true do |t|
    t.integer "episode_id"
  end

end
