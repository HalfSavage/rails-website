class CreateDiscussionsView < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      create or replace view posts_last_replies as 
      SELECT p_last_replies.reply_number,
        p_last_replies.parent_id,
        p_last_replies.created_at,
        p_last_replies.member_id
       FROM ( SELECT row_number() OVER (PARTITION BY p.parent_id ORDER BY p.created_at DESC) AS reply_number,
                p.parent_id,
                p.created_at,
                p.member_id
               FROM posts p
              WHERE p.parent_id IS NOT NULL AND p.is_deleted = false and p.is_private_moderator_voice = false) p_last_replies
      WHERE p_last_replies.reply_number = 1;
    SQL

    execute <<-SQL 
      create or repace view posts_last_replies_with_usernames as 
       SELECT p_last_replies.reply_number,
        p_last_replies.parent_id,
        p_last_replies.created_at,
        p_last_replies.member_id,
        m.username
       FROM ( SELECT row_number() OVER (PARTITION BY p.parent_id ORDER BY p.created_at DESC) AS reply_number,
                p.parent_id,
                p.created_at,
                p.member_id
               FROM posts p
              WHERE p.parent_id IS NOT NULL AND p.is_deleted = false AND p.is_private_moderator_voice = false) p_last_replies
       JOIN members m ON p_last_replies.member_id = m.id
      WHERE p_last_replies.reply_number = 1;
    SQL  

    execute <<-SQL
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
      WHERE p.parent_id IS NULL AND p.is_deleted = false;
    SQL


    # Sorry for the raw SQL here... don't know how to do "desc" ordering in Rails
    execute <<-SQL
      create index ix_posts_for_discussions on posts (parent_id, created_at desc, member_id)
    SQL
  end

  def self.down 
    
    execute <<-SQL
      drop view Discussions
    SQL

    execute <<-SQL
      drop view posts_last_replies
    SQL   

    execute <<-SQL
      drop view posts_last_replies_with_usernames
    SQL    


    execute <<-SQL 
      drop index ix_posts_for_discussions
    SQL
  end


end
