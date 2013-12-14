class ChangeMemberGenderToId < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.remove :gender 
      t.integer :gender_id
    end
  end
end
