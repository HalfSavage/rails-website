class CreateDiscussionsActiveFriends < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION discussions_active_friends(member_id int) 
      RETURNS TABLE(id int, score double precision, usernames varchar[]) as $$
        
      select 
        coalesce(p.parent_id, p.id),
        sum(
            CASE
                WHEN ((date_part('epoch'::text, now()) - date_part('epoch'::text, p.created_at)) < (7200)::double precision) THEN (100.0)::double precision
                ELSE ((1)::double precision + ((100.0)::double precision / ((date_part('epoch'::text, now()) - date_part('epoch'::text, p.created_at)) / (7200.0)::double precision)))
            END) AS score,
        array_agg(m.username)
      from 
        posts p 
          inner join relationships r on 
            p.member_id = r.related_member_id 
            and r.member_id=$1
            and r.friend='t'
            and p.is_deleted='f'
            and p.is_private_moderator_voice='f'
            and p.created_at >= current_date - interval '7 days'
          inner join members m on 
            p.member_id = m.id
      group by coalesce(p.parent_id, p.id)
      order by score desc 
      limit 100

      $$ language sql;
    SQL
  end

  def self.down 
    execute "drop function discussions_active_friends(integer);"
  end 
end
