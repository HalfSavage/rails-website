class CreateGenders < ActiveRecord::Migration
  def change
    create_table :genders do |t|
      t.string :GenderDescription
      t.string :GenderAbbreviation
    end
  end
end
