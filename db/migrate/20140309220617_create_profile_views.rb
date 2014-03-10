class CreateProfileViews < ActiveRecord::Migration
  def change
    create_table :profile_views do |t|
      t.references :member, index: true
      t.integer :viewed_member_id, index: true, null: false, foreign_key: {references: :members}
      t.integer :tally, default: 0
      t.timestamps
    end

    add_index :profile_views, [:viewed_member_id, :member_id,  :tally], unique: true, name: 'profile_views_idx_awesome'
  end
end
