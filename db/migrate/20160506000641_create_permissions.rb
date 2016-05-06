class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :guide
      t.references :user

      t.timestamps null: false
    end
  end
end
