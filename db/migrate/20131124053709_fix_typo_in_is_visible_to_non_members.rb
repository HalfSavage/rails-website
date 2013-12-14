class FixTypoInIsVisibleToNonMembers < ActiveRecord::Migration
  def change
    rename_column :members, :is_visible_ti_non_members, :is_visible_to_non_members
  end
end
