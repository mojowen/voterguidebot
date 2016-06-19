class CreateMeasures < ActiveRecord::Migration
  def up
    create_table :measures do |t|
      t.references :guide
      t.string :title
      t.text :description
      t.text :yes_means
      t.text :no_means

      t.timestamps null: false
    end
    Measure.create_translation_table! description: :text, title: :string,
                                      yes_means: :text, no_means: :text
  end

  def down
    drop_table :measures
    Measure.drop_translation_table!
  end
end
