class AddIsDefaultToForums < ActiveRecord::Migration
  def change
    add_column :forums, :is_default, :boolean
  end
end
