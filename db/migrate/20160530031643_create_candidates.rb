class CreateCandidates < ActiveRecord::Migration
  def up
    create_table :candidates do |t|
      t.references :contest
      t.string :photo
      t.string :name
      t.text :bio

      t.string :facebook
      t.string :website
      t.string :twitter

      t.timestamps null: false
    end
    Candidate.create_translation_table! bio: :text
  end

  def down
    drop_table :candidates
    Candidate.drop_translation_table!
  end
end
