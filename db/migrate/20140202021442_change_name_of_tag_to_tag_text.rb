class ChangeNameOfTagToTagText < ActiveRecord::Migration
  def change
    rename_column :tags, :tag, :tag_text
  end
end
