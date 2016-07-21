class AddPositionToEverything < ActiveRecord::Migration
  def change
    add_column :contests, :position, :integer
    add_column :measures, :position, :integer
    add_column :candidates, :position, :integer
    add_column :questions, :position, :integer
    add_column :endorsements, :position, :integer
  end
end
