class AddDisplayOrderToForums < ActiveRecord::Migration
  def change
    add_column :forums, :display_order, :integer
  end
end
