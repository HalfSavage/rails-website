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

ActiveRecord::Schema.define(version: 20140309230923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.index ["email"], :name => "index_members_on_email", :unique => true
    t.index ["reset_password_token"], :name => "index_members_on_reset_password_token", :unique => true
    t.index ["username"], :name => "index_members_on_username", :unique => true
  end

  create_table "addresses", force: true do |t|
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "region"
    t.string   "country",    limit: 2
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["member_id"], :name => "index_addresses_on_member_id"
    t.foreign_key ["member_id"], "members", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_addresses_member_id"
  end

  create_table "posts", force: true do |t|
    t.integer  "member_id"
    t.integer  "parent_id"
    t.boolean  "is_deleted"
    t.boolean  "is_public_moderator_voice"
    t.boolean  "is_private_moderator_voice"
    t.text     "body"
    t.datetime "marked_as_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.integer  "thread_id"
    t.string   "slug"
    t.index ["created_at", "is_deleted", "is_public_moderator_voice", "is_private_moderator_voice", "parent_id", "id"], :name => "ix_posts_discussions_active", :order => {"created_at" => :desc, "is_deleted" => :asc, "is_public_moderator_voice" => :asc, "is_private_moderator_voice" => :asc, "parent_id" => :asc, "id" => :asc}
    t.index ["parent_id", "created_at", "is_deleted", "is_private_moderator_voice", "member_id"], :name => "posts_idx_for_last_replies", :order => {"parent_id" => :asc, "created_at" => :desc, "is_deleted" => :asc, "is_private_moderator_voice" => :asc, "member_id" => :asc}
    t.index ["parent_id", "is_deleted", "member_id", "created_at", "updated_at", "subject", "id"], :name => "ix_posts_discussions", :order => {"parent_id" => :asc, "is_deleted" => :asc, "member_id" => :asc, "created_at" => :desc, "updated_at" => :asc, "subject" => :asc, "id" => :asc}
    t.index ["slug"], :name => "index_posts_on_slug", :unique => true
  end

  create_table "discussion_views", force: true do |t|
    t.integer  "post_id",                null: false
    t.integer  "member_id",              null: false
    t.integer  "tally",      default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["member_id", "post_id", "updated_at", "tally"], :name => "relationships_idx_covering"
    t.index ["member_id", "post_id"], :name => "discussion_views_idx_member_post", :unique => true
    t.index ["member_id"], :name => "fk__discussion_views_member_id"
    t.index ["member_id"], :name => "index_discussion_views_on_member_id"
    t.index ["post_id"], :name => "fk__discussion_views_post_id"
    t.index ["post_id"], :name => "index_discussion_views_on_post_id"
    t.foreign_key ["member_id"], "members", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_discussion_views_member_id"
    t.foreign_key ["post_id"], "posts", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_discussion_views_post_id"
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
    t.string   "slug"
    t.boolean  "is_default"
  end

  create_table "forums_posts", force: true do |t|
    t.integer "forum_id", null: false
    t.integer "post_id",  null: false
    t.index ["forum_id", "post_id"], :name => "by_forum_and_post", :unique => true
  end

  create_view "posts_last_replies_with_usernames", " SELECT p_last_replies.reply_number, \n    p_last_replies.parent_id, \n    p_last_replies.created_at, \n    p_last_replies.member_id, \n    m.username\n   FROM (( SELECT row_number() OVER (PARTITION BY p.parent_id ORDER BY p.created_at DESC) AS reply_number, \n            p.parent_id, \n            p.created_at, \n            p.member_id\n           FROM posts p\n          WHERE (((p.parent_id IS NOT NULL) AND (p.is_deleted = false)) AND (p.is_private_moderator_voice = false))) p_last_replies\n   JOIN members m ON ((p_last_replies.member_id = m.id)))\n  WHERE (p_last_replies.reply_number = 1)", :force => true
  create_view "discussions", " SELECT f.name, \n    fp.forum_id, \n    p.id, \n    p.member_id, \n    p.body, \n    p.subject, \n    p.created_at, \n    p.updated_at, \n    m.username, \n    ( SELECT count(1) AS count\n           FROM posts preply\n          WHERE ((preply.parent_id = p.id) AND (preply.is_deleted = false))) AS reply_count, \n    plr.created_at AS reply_created_at, \n    plr.username AS reply_username\n   FROM ((((posts p\n   JOIN forums_posts fp ON ((p.id = fp.post_id)))\n   JOIN forums f ON ((fp.forum_id = f.id)))\n   JOIN members m ON ((p.member_id = m.id)))\n   LEFT JOIN posts_last_replies_with_usernames plr ON ((p.id = plr.parent_id)))\n  WHERE ((p.parent_id IS NULL) AND (p.is_deleted = false))\n  ORDER BY COALESCE(plr.created_at, p.created_at) DESC", :force => true
  create_view "discussions_active", " SELECT COALESCE(p.parent_id, p.id) AS id, \n    sum(\n        CASE\n            WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, p.created_at)) < (7200)::double precision) THEN (100.0)::double precision\n            ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, p.created_at)) / (7200.0)::double precision)))\n        END) AS score\n   FROM posts p\n  WHERE ((((p.created_at >= (('now'::text)::date - '7 days'::interval)) AND (p.is_deleted = false)) AND (p.is_public_moderator_voice = false)) AND (p.is_private_moderator_voice = false))\n  GROUP BY COALESCE(p.parent_id, p.id)", :force => true
  create_table "forum_moderators", force: true do |t|
    t.string   "forum_moderators"
    t.integer  "forum_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genders", force: true do |t|
    t.string "gender_description"
    t.string "gender_abbreviation"
  end

  create_table "likes", force: true do |t|
    t.integer  "member_id"
    t.integer  "post_id"
    t.integer  "attachment_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["post_id", "member_id"], :name => "index_likes_on_post_id_and_member_id", :unique => true
  end

  create_table "message_types", force: true do |t|
    t.string "name"
  end

  create_table "messages", force: true do |t|
    t.integer  "member_to_id"
    t.integer  "member_from_id"
    t.integer  "message_type_id"
    t.string   "body",                 limit: 8000
    t.datetime "seen"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_by_sender"
    t.datetime "deleted_by_recipient"
    t.boolean  "is_moderator_voice"
    t.index ["member_to_id", "message_type_id"], :name => "index_messages_on_member_to_id_and_message_type_id"
    t.index ["member_to_id", "seen", "message_type_id"], :name => "index_messages_on_member_to_id_and_seen_and_message_type_id"
  end

  create_table "post_action_types", force: true do |t|
    t.string   "name"
    t.boolean  "moderator_only"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "note_required"
  end

  create_table "post_actions", force: true do |t|
    t.integer  "member_id"
    t.integer  "post_action_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.string   "note"
    t.index ["post_id", "post_action_type_id", "created_at"], :name => "post_actions_post_id_etc"
  end

  create_view "post_last_replies", " SELECT p_last_replies.reply_number, \n    p_last_replies.parent_id, \n    p_last_replies.created_at, \n    p_last_replies.member_id\n   FROM ( SELECT row_number() OVER (PARTITION BY p.parent_id ORDER BY p.created_at DESC) AS reply_number, \n            p.parent_id, \n            p.created_at, \n            p.member_id\n           FROM posts p\n          WHERE (((p.parent_id IS NOT NULL) AND (p.is_deleted = false)) AND (p.is_private_moderator_voice = false))) p_last_replies\n  WHERE (p_last_replies.reply_number = 1)", :force => true
  create_table "post_tags", id: false, force: true do |t|
    t.integer  "post_id",    null: false
    t.integer  "tag_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_view "posts_last_replies", " SELECT p_last_replies.reply_number, \n    p_last_replies.parent_id, \n    p_last_replies.created_at, \n    p_last_replies.member_id\n   FROM ( SELECT row_number() OVER (PARTITION BY p.parent_id ORDER BY p.created_at DESC) AS reply_number, \n            p.parent_id, \n            p.created_at, \n            p.member_id\n           FROM posts p\n          WHERE (((p.parent_id IS NOT NULL) AND (p.is_deleted = false)) AND (p.is_private_moderator_voice = false))) p_last_replies\n  WHERE (p_last_replies.reply_number = 1)", :force => true
  create_table "profile_views", force: true do |t|
    t.integer  "member_id"
    t.integer  "viewed_member_id",             null: false
    t.integer  "tally",            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["member_id"], :name => "fk__profile_views_member_id"
    t.index ["member_id"], :name => "index_profile_views_on_member_id"
    t.index ["viewed_member_id", "member_id", "tally"], :name => "profile_views_idx_awesome", :unique => true
    t.index ["viewed_member_id"], :name => "index_profile_views_on_viewed_member_id"
    t.foreign_key ["member_id"], "members", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_profile_views_member_id"
    t.foreign_key ["viewed_member_id"], "members", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_profile_views_viewed_member_id"
  end

  create_table "relationships", force: true do |t|
    t.integer  "member_id"
    t.integer  "related_member_id"
    t.boolean  "friend",                    default: false
    t.boolean  "blocked",                   default: false
    t.boolean  "may_view_private_pictures", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["member_id", "related_member_id", "friend", "blocked", "may_view_private_pictures"], :name => "relationships_idx_all"
    t.index ["member_id", "related_member_id", "friend"], :name => "relationships_idx_friend", :unique => true
    t.index ["member_id"], :name => "index_relationships_on_member_id"
    t.index ["related_member_id"], :name => "index_relationships_on_related_member_id"
    t.foreign_key ["member_id"], "members", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_relationships_member_id"
    t.foreign_key ["related_member_id"], "members", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_relationships_related_member_id"
  end

  create_table "tags", force: true do |t|
    t.string   "tag_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_view "tags_trending", " SELECT pt.tag_id, \n    t.tag_text, \n    count(pt.tag_id) AS count, \n    sum(\n        CASE\n            WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) < (7200)::double precision) THEN (100.0)::double precision\n            ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) / (7200.0)::double precision)))\n        END) AS score\n   FROM ((post_tags pt\n   JOIN forums_posts fp ON ((pt.post_id = fp.post_id)))\n   JOIN tags t ON ((pt.tag_id = t.id)))\n  GROUP BY pt.tag_id, t.tag_text\n  ORDER BY sum(\nCASE\n    WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) < (7200)::double precision) THEN (100.0)::double precision\n    ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) / (7200.0)::double precision)))\nEND) DESC\n LIMIT 100", :force => true
  create_view "tags_trending_by_forum", " SELECT pt.tag_id, \n    t.tag_text, \n    count(pt.tag_id) AS count, \n    fp.forum_id, \n    sum(\n        CASE\n            WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) < (7200)::double precision) THEN (100.0)::double precision\n            ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) / (7200.0)::double precision)))\n        END) AS score\n   FROM ((post_tags pt\n   JOIN forums_posts fp ON ((pt.post_id = fp.post_id)))\n   JOIN tags t ON ((pt.tag_id = t.id)))\n  GROUP BY fp.forum_id, pt.tag_id, t.tag_text\n  ORDER BY sum(\nCASE\n    WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) < (7200)::double precision) THEN (100.0)::double precision\n    ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) / (7200.0)::double precision)))\nEND) DESC\n LIMIT 100", :force => true
end
