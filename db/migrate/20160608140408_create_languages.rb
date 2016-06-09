class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.references :guide
      t.string :code

      t.timestamps null: false
    end
  end
end
