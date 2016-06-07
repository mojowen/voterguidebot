class CreateAnswers < ActiveRecord::Migration
  def up
    create_table :answers do |t|
      t.references :candidate
      t.references :question
      t.string :text

      t.timestamps null: false
    end
    Answer.create_translation_table! text: :string
  end

  def down
    drop_table :answers
    Answer.drop_translation_table!
  end
end
