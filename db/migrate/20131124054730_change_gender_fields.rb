class ChangeGenderFields < ActiveRecord::Migration
  def change
    rename_column :genders, :GenderDescription, :gender_description
    rename_column :genders, :GenderAbbreviation, :gender_abbreviation
  end
end
