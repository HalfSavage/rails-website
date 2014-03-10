class CreateActiveThreadsViewAndIndex < ActiveRecord::Migration
  def self.up
    execute <<-SQL
    CREATE or replace VIEW "public"."discussions_active" AS  SELECT COALESCE(p.parent_id, p.id) AS id, 
      sum(
          CASE
              WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, p.created_at)) < (7200)::double precision) THEN (100.0)::double precision
              ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, p.created_at)) / (7200.0)::double precision)))
          END) AS score
     FROM posts p
     where 
      created_at >= current_date - interval '7 days'
      and is_deleted = false 
      and  is_public_moderator_voice = false 
      and is_private_moderator_voice = false
    GROUP BY COALESCE(p.parent_id, p.id);
    SQL

    execute <<-SQL
      create index ix_posts_discussions_active on posts (created_at desc, is_deleted, is_public_moderator_voice, is_private_moderator_voice, parent_id, id);
    SQL
  end

  def self.down
    execute <<-SQL 
      drop index ix_posts_discussions_active;
    SQL

    execute <<-SQL 
      drop view discussions_active;
    SQL
  end
end
