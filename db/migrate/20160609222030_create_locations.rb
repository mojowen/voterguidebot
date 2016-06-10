class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :guide
      t.string :address
      t.string :city
      t.string :state

      t.decimal :lat
      t.decimal :lng

      t.decimal :west
      t.decimal :east
      t.decimal :north
      t.decimal :south

      t.timestamps null: false
    end
  end
end
