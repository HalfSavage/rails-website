class AddModeratorVoiceToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :is_moderator_voice, :boolean
  end
end
