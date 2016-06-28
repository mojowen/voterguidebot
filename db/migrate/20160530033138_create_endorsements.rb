class CreateEndorsements < ActiveRecord::Migration
  def up
    create_table :endorsements do |t|
      t.references :endorsed, polymorphic: true, index: true
      t.string :endorser
      t.integer :stance, default: 0, index: true

      t.timestamps null: false
    end
    Endorsement.create_translation_table! endorser: :string
  end

  def down
    drop_table :endorsements
    Endorsement.drop_translation_table!
  end
end
