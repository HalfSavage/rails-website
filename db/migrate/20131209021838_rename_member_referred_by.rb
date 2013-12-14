class RenameMemberReferredBy < ActiveRecord::Migration
  def change
    rename_column :members, :member_id_referred, :referred_by_id
  end
end
