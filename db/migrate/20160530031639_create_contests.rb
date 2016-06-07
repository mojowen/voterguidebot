class CreateContests < ActiveRecord::Migration
  def up
    create_table :contests do |t|
      t.references :guide
      t.string :title
      t.text :description
      t.boolean :publish

      t.timestamps null: false
    end
    Contest.create_translation_table! description: :text, title: :string
  end

  def down
    drop_table :contests
    Contest.drop_translation_table!
  end
end
