class CreateDiscussionsView < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      -- We call it "ForumThreads" and not "Threads" since "Thread" is a reserved keyword in Ruby
      create or replace view Discussions
      as
      select
        f.name,
        fp.forum_id,
        p.id as id,
        p.member_id as member_id,
        p.body,
        p.subject,
        p.created_at,
        p.updated_at,
        m.username,
        (select count(1) from posts pReply where pReply.parent_id = p.id and is_deleted=false) as reply_count,
        pLastReply.reply_created_at,
        pLastReply.reply_username
      from
        posts p 
          inner join forums_posts fp on p.id = fp.post_id
          inner join forums f on fp.forum_id = f.id 
          inner join members m on p.member_id = m.id 
          left outer join (
            -- This anonymous table contains the most recent reply for each thread
            select
              rank() over (partition by parent_id order by p.created_at desc) as reply_number,
              p.parent_id,
              p.created_at as reply_created_at,
              m.username as reply_username,
              m.id as reply_member_id
            from
              posts p inner join members m on p.member_id = m.id
            where
              p.parent_id is not null
              and is_deleted is not null
          ) pLastReply on p.id = pLastReply.parent_id and pLastReply.reply_number=1
      where
        p.parent_id is null
        and is_deleted=false
      order by 
        coalesce(pLastReply.reply_created_at, p.created_at) desc
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
      drop index ix_posts_for_discussions
    SQL
  end


end
