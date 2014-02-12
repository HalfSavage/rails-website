class AddLowercaseTagIndexToTags < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      CREATE UNIQUE INDEX tag_tag_text_lower ON tags (LOWER(tag_text));
    SQL
  end

  def self.down
    execute <<-SQL
      drop index tag_tag_text_lower;
    SQL
  end 
end
