class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.references :guide, null: false
      t.text :value
      t.string :field_template, index: true, null: false

      t.timestamps null: false
    end
  end
end
