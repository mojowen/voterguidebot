class CreateFields < ActiveRecord::Migration
  def up
    create_table :fields do |t|
      t.references :guide, null: false
      t.text :value
      t.string :field_template, index: true, null: false

      t.timestamps null: false
    end
    Field.create_translation_table! value: :text
  end

  def down
    drop_table :fields
    Field.drop_translation_table!
  end
end
