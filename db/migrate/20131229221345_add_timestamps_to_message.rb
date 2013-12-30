class AddTimestampsToMessage < ActiveRecord::Migration
  def change
    change_table(:messages) { |t| 
      t.timestamps
      t.datetime :deleted_by_sender
      t.datetime :deleted_by_recipient
    }
  end
end
