class CreateExports < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.references :user, null: false
      t.integer :status, default: 0

      t.timestamps null: false
    end

    create_table :export_guides do |t|
      t.references :export, null: false
      t.references :guide, null: false
      t.string :export_version

      t.timestamps null: false
    end
  end
end
