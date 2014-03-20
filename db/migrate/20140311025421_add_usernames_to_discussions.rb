class AddUsernamesToDiscussions < ActiveRecord::Migration
  def self.up
    execute "drop view Discussions"

    execute <<-SQL
      -- We call it "ForumThreads" and not "Threads" since "Thread" is a reserved keyword in Ruby
      create or replace view Discussions
      as
       SELECT f.name,
        fp.forum_id,
        p.id,
        p.member_id,
        p.body,
        p.subject,
        p.created_at,
        p.updated_at,
        m.username,
        ( SELECT count(1) AS count
               FROM posts preply
              WHERE preply.parent_id = p.id AND preply.is_deleted = false) AS reply_count,
        plr.created_at AS reply_created_at,
        plr.username AS reply_username,
        '' as usernames
       FROM posts p
       JOIN forums_posts fp ON p.id = fp.post_id
       JOIN forums f ON fp.forum_id = f.id
       JOIN members m ON p.member_id = m.id
       LEFT JOIN posts_last_replies_with_usernames plr ON p.id = plr.parent_id
      WHERE p.parent_id IS NULL AND p.is_deleted = false
      ORDER BY COALESCE(plr.created_at, p.created_at) DESC;
    SQL

  end 

  def self.down
    execute "drop view Discussions"

    execute <<-SQL
      -- We call it "ForumThreads" and not "Threads" since "Thread" is a reserved keyword in Ruby
      create or replace view Discussions
      as
       SELECT f.name,
        fp.forum_id,
        p.id,
        p.member_id,
        p.body,
        p.subject,
        p.created_at,
        p.updated_at,
        m.username,
        ( SELECT count(1) AS count
               FROM posts preply
              WHERE preply.parent_id = p.id AND preply.is_deleted = false) AS reply_count,
        plr.created_at AS reply_created_at,
        plr.username AS reply_username
       FROM posts p
       JOIN forums_posts fp ON p.id = fp.post_id
       JOIN forums f ON fp.forum_id = f.id
       JOIN members m ON p.member_id = m.id
       LEFT JOIN posts_last_replies_with_usernames plr ON p.id = plr.parent_id
      WHERE p.parent_id IS NULL AND p.is_deleted = false
      ORDER BY COALESCE(plr.created_at, p.created_at) DESC;
    SQL
  end
end
