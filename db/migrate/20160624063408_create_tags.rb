class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :tagged, polymorphic: true, index: true
      t.string :name, index: true

      t.timestamps null: false
    end
  end
end
