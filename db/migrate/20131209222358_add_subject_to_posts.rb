class AddSubjectToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :subject, :string
    remove_column :posts, :thread_id, :integer
  end
end
