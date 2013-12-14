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

ActiveRecord::Schema.define(version: 20131211231328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "forum_moderators", force: true do |t|
    t.string   "forum_moderators"
    t.integer  "forum_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", force: true do |t|
    t.string   "name"
    t.boolean  "is_active"
    t.boolean  "is_moderator_only"
    t.boolean  "is_visible_to_public"
    t.boolean  "is_paid_member_only"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "display_order"
  end

  create_table "forums_posts", force: true do |t|
    t.integer "forum_id", null: false
    t.integer "post_id",  null: false
  end

  add_index "forums_posts", ["forum_id", "post_id"], name: "by_forum_and_post", unique: true, using: :btree

  create_table "genders", force: true do |t|
    t.string "gender_description"
    t.string "gender_abbreviation"
  end

  create_table "members", force: true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "referred_by_id"
    t.datetime "date_of_birth"
    t.boolean  "is_active"
    t.boolean  "is_moderator"
    t.boolean  "is_supermoderator"
    t.boolean  "is_banned"
    t.boolean  "is_vip"
    t.boolean  "is_true_successor_to_hokuto_no_ken"
    t.boolean  "is_visible_to_non_members"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "gender_id"
  end

  add_index "members", ["email"], name: "index_members_on_email", unique: true, using: :btree
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree

  create_table "messages", force: true do |t|
    t.integer  "member_id"
    t.integer  "message_type_id"
    t.string   "body"
    t.boolean  "seen"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reply_to_post_id"
  end

  create_table "post_actions", force: true do |t|
    t.integer  "member_id"
    t.integer  "post_action_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.integer  "member_id"
    t.integer  "reply_to_post_id"
    t.boolean  "is_deleted"
    t.boolean  "is_public_moderator_voice"
    t.boolean  "is_private_moderator_voice"
    t.text     "body"
    t.datetime "marked_as_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
  end

end
