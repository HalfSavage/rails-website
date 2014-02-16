class CreateTagsTrending < ActiveRecord::Migration
  def self.up
    execute <<-SQL
       create or replace view tags_trending as
       SELECT pt.tag_id,
          t.tag_text,
          count(pt.tag_id) AS count,
          fp.forum_id,
          sum(
              CASE
                  WHEN (date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) < 7200::double precision THEN 100.0::double precision
                  ELSE 1::double precision + 100.0::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) / 7200.0::double precision)
              END) AS score
         FROM post_tags pt
         JOIN forums_posts fp ON pt.post_id = fp.post_id
         JOIN tags t ON pt.tag_id = t.id
        GROUP BY fp.forum_id, pt.tag_id, t.tag_text
        ORDER BY sum(
      CASE
          WHEN (date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) < 7200::double precision THEN 100.0::double precision
          ELSE 1::double precision + 100.0::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, pt.created_at)) / 7200.0::double precision)
      END) DESC
       LIMIT 100;
    SQL

  end

  def self.down 
    execute <<-SQL
      drop view tags_trending;
    SQL
  end 
end
