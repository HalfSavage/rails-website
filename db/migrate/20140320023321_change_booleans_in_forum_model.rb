class ChangeBooleansInForumModel < ActiveRecord::Migration
  def change
    rename_column :forums, :is_active, :active 
    rename_column :forums, :is_moderator_only, :moderator_only
    rename_column :forums, :is_visible_to_public, :visible_to_public
    rename_column :forums, :is_paid_member_only, :paid_member_only
    rename_column :forums, :is_default, :default_forum
  end
end
