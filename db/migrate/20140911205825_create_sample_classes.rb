class CreateSampleClasses < ActiveRecord::Migration
  def change
    create_table :sample_classes do |t|
      t.string :description
      t.integer :number_of_bloits

      t.timestamps
    end
  end
end
