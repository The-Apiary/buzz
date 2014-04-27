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

ActiveRecord::Schema.define(version: 20140427151214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.text "name"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree

  create_table "categories_podcasts", id: false, force: true do |t|
    t.integer "podcast_id"
    t.integer "category_id"
  end

  add_index "categories_podcasts", ["category_id"], name: "index_categories_podcasts_on_category_id", using: :btree
  add_index "categories_podcasts", ["podcast_id"], name: "index_categories_podcasts_on_podcast_id", using: :btree

  create_table "episode_data", force: true do |t|
    t.integer  "episode_id"
    t.integer  "current_position", default: 0
    t.boolean  "is_played"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "episode_data", ["episode_id"], name: "index_episode_data_on_episode_id", using: :btree
  add_index "episode_data", ["user_id", "episode_id"], name: "index_episode_data_on_user_id_and_episode_id", using: :btree
  add_index "episode_data", ["user_id"], name: "index_episode_data_on_user_id", using: :btree

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
    t.string   "episode_type"
  end

  add_index "episodes", ["podcast_id"], name: "index_episodes_on_podcast_id", using: :btree
  add_index "episodes", ["publication_date"], name: "index_episodes_on_publication_date", using: :btree

  create_table "podcasts", force: true do |t|
    t.string   "title"
    t.string   "image_url"
    t.string   "feed_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.text     "link_url"
    t.integer  "subscriptions_count", default: 0
  end

  add_index "podcasts", ["subscriptions_count"], name: "index_podcasts_on_subscriptions_count", using: :btree
  add_index "podcasts", ["title"], name: "index_podcasts_on_title", using: :btree

  create_table "queued_episodes", force: true do |t|
    t.integer "episode_id"
    t.integer "user_id"
    t.integer "idx",        default: 0
  end

  add_index "queued_episodes", ["episode_id"], name: "index_queued_episodes_on_episode_id", using: :btree
  add_index "queued_episodes", ["user_id"], name: "index_queued_episodes_on_user_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "podcast_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "subscription_type", default: "Normal", null: false
  end

  add_index "subscriptions", ["podcast_id"], name: "index_subscriptions_on_podcast_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "id_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "last_login",       default: '2014-03-30 22:33:30'
    t.string   "image"
  end

  add_index "users", ["id_hash"], name: "index_users_on_id_hash", using: :btree

end
