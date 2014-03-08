class CreateTagsTrendingView < ActiveRecord::Migration
  def self.up
    execute <<-SQL
    CREATE OR REPLACE VIEW "public"."tags_trending" AS  SELECT pt.tag_id, 
      t.tag_text, 
      count(pt.tag_id) AS count, 
      sum(
          CASE
              WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) < (7200)::double precision) THEN (100.0)::double precision
              ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) / (7200.0)::double precision)))
          END) AS score
    FROM ((post_tags pt
     JOIN forums_posts fp ON ((pt.post_id = fp.post_id)))
     JOIN tags t ON ((pt.tag_id = t.id)))
    GROUP BY pt.tag_id, t.tag_text
    ORDER BY score DESC
    LIMIT 100;
    SQL

  end

  def self.down 
    execute <<-SQL
      drop view tags_trending;
    SQL
  end 
end