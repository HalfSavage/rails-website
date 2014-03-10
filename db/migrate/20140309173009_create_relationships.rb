class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.references :member, index: true
      t.integer :related_member_id, index:true, foreign_key: { references: :members}
      t.boolean :friend, default: false
      t.boolean :blocked, default: false 
      t.boolean :may_view_private_pictures, default: false

      t.timestamps
    end

    # supply our own names, because the auto-generated names will be too long for Postgres to handle
    add_index :relationships, [:member_id, :related_member_id, :friend], unique: true, name: 'relationships_idx_friend'
    add_index :relationships, [:member_id, :related_member_id, :friend, :blocked, :may_view_private_pictures], name: 'relationships_idx_all'
  end
end
