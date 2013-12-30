class AddNoteToPostActions < ActiveRecord::Migration
  def change
    add_column :post_actions, :note, :string
    add_column :post_action_types, :note_required, :boolean
  end
end
