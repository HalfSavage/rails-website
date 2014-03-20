class ChangeBooleansInMemberModel < ActiveRecord::Migration
  def change
    rename_column :members, :is_active, :active 
    rename_column :members, :is_moderator, :moderator 
    rename_column :members, :is_supermoderator, :supermoderator 
    rename_column :members, :is_banned, :banned 
    rename_column :members, :is_vip, :vip
    rename_column :members, :is_true_successor_to_hokuto_no_ken, :true_successor_to_hokuto_no_ken
    rename_column :members, :is_visible_to_non_members, :visible_to_non_members
  end
end
