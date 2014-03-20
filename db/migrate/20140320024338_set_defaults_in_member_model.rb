class SetDefaultsInMemberModel < ActiveRecord::Migration
  def change
    change_column :members, :active, :boolean, :default => true
    change_column :members, :moderator, :boolean, :default => false
    change_column :members, :supermoderator, :boolean, :default => false
    change_column :members, :banned, :boolean, :default => false
    change_column :members, :vip, :boolean, :default => false
    change_column :members, :true_successor_to_hokuto_no_ken, :boolean, :default => false
    change_column :members, :visible_to_non_members, :boolean, :default => false
  end
end
