class CreateEndorsements < ActiveRecord::Migration
  def up
    create_table :endorsements do |t|
      t.references :candidate
      t.string :endorser

      t.timestamps null: false
    end
    Endorsement.create_translation_table! endorser: :string
  end

  def down
    drop_table :endorsements
    Endorsement.drop_translation_table!
  end
end
