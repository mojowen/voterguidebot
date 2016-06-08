class CreateUploads < ActiveRecord::Migration
  def up
    create_table :uploads do |t|
      t.references :user
      t.timestamps null: false
    end

    add_attachment :uploads, :file
  end

  def down
    remove_attachment :uploads, :file
    drop_table :uploads
  end
end
