class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :region
      t.column :country, "char(2)"
      t.column :latitude, "double precision"
      t.column :longitude, "double precision"
      t.belongs_to :member, index: true

      t.timestamps
    end
  end
end
