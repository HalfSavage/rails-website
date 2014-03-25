class SetDefaultsInPostModel < ActiveRecord::Migration
  def change
    change_column :posts, :deleted, :boolean, :default => false
    change_column :posts, :public_moderator_voice, :boolean, :default => false
    change_column :posts, :private_moderator_voice, :boolean, :default => false

  end
end
