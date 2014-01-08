class AddSlugToForums < ActiveRecord::Migration
  def change
    add_column :forums, :slug, :string
  end
end
