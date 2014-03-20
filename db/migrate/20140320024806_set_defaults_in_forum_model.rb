class SetDefaultsInForumModel < ActiveRecord::Migration
  def change
    change_column :forums, :active, :boolean, :default => true
    change_column :forums, :moderator_only, :boolean, :default => false
    change_column :forums, :visible_to_public, :boolean, :default => true
    change_column :forums, :paid_member_only, :boolean, :default => true
  end
end
