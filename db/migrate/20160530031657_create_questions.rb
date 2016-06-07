class CreateQuestions < ActiveRecord::Migration
  def up
    create_table :questions do |t|
      t.references :contest
      t.string :text
      t.boolean :publish

      t.timestamps null: false
    end
    Question.create_translation_table! text: :string
  end

  def down
    drop_table :questions
    Question.drop_translation_table!
  end
end
