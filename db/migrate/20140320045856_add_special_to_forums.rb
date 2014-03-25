class AddSpecialToForums < ActiveRecord::Migration
  def change
    add_column :forums, :special, :boolean, default: false
  end
end
