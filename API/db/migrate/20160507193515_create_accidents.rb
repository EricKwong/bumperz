class CreateAccidents < ActiveRecord::Migration
  def change
    create_table :accidents do |t|
      t.date :date
      t.time :time
      t.string :borough
      t.integer :zip_code
      t.float :latitude
      t.float :longitude
      t.string :on_street
      t.string :cross_street
      t.integer :injured
      t.integer :killed
    end
  end
end
