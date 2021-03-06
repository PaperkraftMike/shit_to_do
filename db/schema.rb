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

ActiveRecord::Schema.define(version: 20130728191901) do

  create_table "friendships", force: true do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.boolean "requested"
    t.boolean "pending"
    t.boolean "confirmed"
  end

  create_table "tasks", force: true do |t|
    t.string   "tname"
    t.string   "tdisc"
    t.datetime "created_at"
    t.datetime "completed_at"
    t.string   "ttime"
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "location"
    t.boolean  "completed"
    t.boolean  "task_public"
    t.boolean  "task_private"
    t.boolean  "pending"
    t.boolean  "approved"
    t.string   "tdate"
  end

  create_table "users", force: true do |t|
    t.string  "fname"
    t.string  "lname"
    t.string  "email"
    t.string  "password"
    t.string  "city"
    t.string  "state"
    t.integer "zipcode"
    t.text    "bio"
    t.integer "tasks"
    t.string  "password_hash"
    t.string  "password_salt"
  end

end
